{ config, pkgs, ... }:

let
  remoteResolution = pkgs.writeShellApplication {
    name = "wayvnc-resolution";
    runtimeInputs = [ pkgs.coreutils pkgs.hyprland pkgs.jq pkgs.wayvnc ];
    text = ''
      saved_rule="$XDG_RUNTIME_DIR/wayvnc-resolution/monitor-rule"

      set_monitor() {
        local output mode position scale _transform_label transform result
        if [ "$(hyprctl -j status | jq -r '.configProvider')" = lua ]; then
          IFS=, read -r output mode position scale _transform_label transform <<< "$1"
          result=$(hyprctl eval "hl.monitor({output=$(jq -Rn --arg v "$output" '$v'),mode=$(jq -Rn --arg v "$mode" '$v'),position=$(jq -Rn --arg v "$position" '$v'),scale=$scale,transform=''${transform:-0}})")
        else
          result=$(hyprctl keyword monitor "$1")
        fi
        if [ "$result" != ok ]; then
          echo "Failed to configure monitor: $result" >&2
          return 1
        fi
      }

      restore() {
        if [ -s "$saved_rule" ]; then
          set_monitor "$(cat "$saved_rule")"
          rm "$saved_rule"
          echo "Restored the local monitor settings."
        fi
      }

      connected() {
        local output monitor mode position
        output=$(wayvncctl --json output-list | jq -er '.[] | select(.captured) | .name')
        # The virtual fallback always runs at 1440p.
        if [ "$output" = VNC-FALLBACK ]; then
          return
        fi
        monitor=$(hyprctl -j monitors | jq -ec --arg name "$output" '.[] | select(.name == $name)')
        mode=$(jq -r '
          ([.availableModes[] | select(startswith("2560x1440@"))][0] //
           [.availableModes[] | select(startswith("1920x1080@"))][0] // "") |
          sub("Hz$"; "")' <<< "$monitor")
        if [ -z "$mode" ]; then
          echo "No supported 1440p or 1080p mode on $output; keeping its resolution."
          return
        fi
        # Reapply the remote mode after HDMI reconnects, preserving the original.
        if [ ! -s "$saved_rule" ]; then
          jq -r '"\(.name),\(.width)x\(.height)@\(.refreshRate),\(.x)x\(.y),\(.scale),transform,\(.transform)"' \
            <<< "$monitor" > "$saved_rule"
        fi
        position=$(jq -r '"\(.x)x\(.y)"' <<< "$monitor")
        set_monitor "$output,$mode,$position,1,transform,0"
        echo "Remote desktop resolution: $mode on $output."
      }

      if [ "''${1:-}" = restore ]; then
        restore
        exit 0
      fi

      while IFS= read -r event; do
        case "$(jq -r '.method' <<< "$event")" in
          client-connected)
            connected
            ;;
          client-disconnected)
            if [ "$(jq -r '.params.connection_count' <<< "$event")" = 0 ]; then
              restore
            fi
            ;;
          output-added)
            if [ "$(jq -r '.params.name' <<< "$event")" = HDMI-A-1 ]; then
              wayvncctl output-set HDMI-A-1
              if [ "$(wayvncctl --json client-list | jq length)" -gt 0 ]; then
                connected
              fi
            fi
            ;;
          wayvnc-startup)
            # Also handle activation/restarting the watcher during a connection.
            if [ "$(wayvncctl --json client-list | jq length)" -gt 0 ]; then
              connected
            else
              restore
            fi
            ;;
          wayvnc-shutdown)
            restore
            ;;
        esac
      done < <(wayvncctl --wait --reconnect --json event-receive)
    '';
  };

  # This module is imported only on minipc. Never listen on every interface.
  startWayvnc = pkgs.writeShellApplication {
    name = "start-wayvnc";
    runtimeInputs = [ pkgs.coreutils pkgs.hyprland pkgs.iproute2 pkgs.jq pkgs.openssl pkgs.wayvnc ];
    text = ''
      address=$(ip -j -4 address show dev wlp2s0 | jq -r '
        [.[].addr_info[] | select(.scope == "global") |
         .local | select(startswith("192.168.2."))][0] // empty')
      if [ -z "$address" ]; then
        echo "Waiting for a Wi-Fi address on the home LAN (192.168.2.0/24)." >&2
        exit 1
      fi

      umask 077
      state_dir="${config.xdg.stateHome}/wayvnc"
      mkdir -p "$state_dir"
      chmod 700 "$state_dir"

      # Credentials stay outside the repository and the world-readable Nix store.
      if [ ! -s "$state_dir/credentials" ]; then
        password=$(openssl rand -hex 16)
        printf 'username=elias\npassword=%s\n' "$password" > "$state_dir/credentials"
      fi
      if [ ! -s "$state_dir/tls_key.pem" ] || [ ! -s "$state_dir/tls_cert.pem" ]; then
        openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:secp384r1 \
          -sha384 -days 3650 -nodes \
          -keyout "$state_dir/tls_key.pem" -out "$state_dir/tls_cert.pem" \
          -subj /CN=minipc -addext "subjectAltName=DNS:minipc,IP:$address"
      fi

      runtime_config="$XDG_RUNTIME_DIR/wayvnc/config"
      cat > "$runtime_config" <<EOF
      address=$address
      port=5900
      enable_auth=true
      private_key_file=$state_dir/tls_key.pem
      certificate_file=$state_dir/tls_cert.pem
      xkb_layout=se
      xkb_variant=mac
      EOF
      cat "$state_dir/credentials" >> "$runtime_config"

      # Keep a real Wayland output available when the HDMI monitor powers off.
      # Keep it independent: the mirrored handover test crashed in Hyprland's
      # cursor capture code. This output is an extended desktop.
      if ! hyprctl -j monitors all | jq -e '.[] | select(.name == "VNC-FALLBACK")' >/dev/null; then
        hyprctl output create headless VNC-FALLBACK
      fi
      output=$(hyprctl -j monitors | jq -er '
        ([.[] | select(.name != "VNC-FALLBACK") | .name][0]) // "VNC-FALLBACK"')
      # The connection hook owns the resolution, rather than the viewer's size.
      exec wayvnc --render-cursor --disable-resizing --output="$output" --config="$runtime_config"
    '';
  };
in
{
  home.packages = [ pkgs.wayvnc ];

  wayland.windowManager.hyprland.settings.monitor = [
    "VNC-FALLBACK,2560x1440@60,auto-right,1"
  ];

  systemd.user.services.wayvnc-resolution = {
    Unit = {
      Description = "Use a 16:9 resolution while VNC clients are connected";
      Requires = [ "wayvnc.service" ];
      After = [ "wayvnc.service" ];
      PartOf = [ "wayvnc.service" "hyprland-session.target" ];
    };
    Service = {
      ExecStart = "${remoteResolution}/bin/wayvnc-resolution";
      ExecStopPost = "${remoteResolution}/bin/wayvnc-resolution restore";
      Restart = "always";
      RestartSec = 2;
      RuntimeDirectory = "wayvnc-resolution";
      RuntimeDirectoryMode = "0700";
      UMask = "0077";
    };
    Install.WantedBy = [ "wayvnc.service" ];
  };

  systemd.user.services.wayvnc = {
    Unit = {
      Description = "Share the Hyprland desktop over VNC on the home Wi-Fi";
      After = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
      StartLimitIntervalSec = 0;
    };
    Service = {
      ExecStart = "${startWayvnc}/bin/start-wayvnc";
      # WayVNC can exit successfully when its last output disappears.
      Restart = "always";
      RestartSec = 2;
      RuntimeDirectory = "wayvnc";
      RuntimeDirectoryMode = "0700";
      UMask = "0077";
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };
}
