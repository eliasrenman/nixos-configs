## Installation

1. Download [NixOS ISO](https://nixos.org/nixos/download.html)
2. Write the ISO to a USB drive using `dd`
3. Boot machine from ISO
4. Install git: `nix-env -i git`
5. Clone configuration: `git clone https://github.com/eliasrenman/nixos-configs.git`
6. Reboot
7. Login as root
8. Set user password: `passwd <username>`
9. Log out and login as user (desktop session depends on host config, see table below)

## Available Hosts

| Host | Desktop | Description |
|------|---------|-------------|
| `laptop` | GNOME | Laptop configuration |
| `minipc` | Hyprland | Mini PC configuration |
| `wsl` | CLI only | Windows Subsystem for Linux |

## Usage

Use the build script to rebuild your system:

```bash
./build.sh <host> <command>

# Examples:
./build.sh laptop switch    # Build and switch to new config
./build.sh minipc build     # Build without switching
./build.sh wsl dry-build    # Test build without applying
```

Available commands: `switch`, `boot`, `test`, `build`, `dry-build`, `dry-activate`

## Remote desktop (minipc)

Home Manager starts WayVNC with the Hyprland session. It shares the existing
desktop and requires that Elias is logged in to Hyprland; it does not provide a
remote login screen. Apply changes with `home-manager switch`.

A 2560×1440 virtual display (`VNC-FALLBACK`) is created only when no physical
monitor is available. If the last monitor is turned off or unplugged, WayVNC
restarts and creates this fallback so headless access remains available (an
active viewer may need to reconnect). When a physical monitor returns, capture
switches back to it and the virtual display is removed, bringing its workspaces
and windows back onto the real screen. There is no invisible extended desktop
while a physical monitor is available, even when no VNC viewer is connected.
WayVNC restarts after unexpected exits, including successful exits caused by
losing an output.
The cursor is rendered into the video by WayVNC for visibility in TigerVNC.

When the first VNC client connects, the shared monitor switches to 2560×1440 if
it advertises that mode, otherwise 1920×1080, at scale 1. The current Dell
ultrawide supports the 1080p option. The original resolution, refresh rate,
position, scale, and rotation return when the last client disconnects or the
service stops. This also changes the physical display while connected. Viewer
window resizing does not override this resolution.

Connect over the home LAN or VPN using a VNC client with VeNCrypt/TLS support,
such as TigerVNC. The current address is `192.168.2.87:5900` (in TigerVNC,
`192.168.2.87::5900`). The username is `elias`. Read the generated password locally:

```bash
cat ~/.local/state/wayvnc/credentials
```

The first connection uses a self-signed certificate. Its fingerprint is available
with `openssl x509 -in ~/.local/state/wayvnc/tls_cert.pem -noout -sha256 -fingerprint`.
Credentials and private keys are generated locally and never stored in Git or
the Nix store. To change the password, edit the `password=` line in the credentials
file and run `systemctl --user restart wayvnc`.

The server binds only to the IPv4 address of `wlp2s0` on `192.168.2.0/24`, with
authentication and encryption required. Reserve this device's address in the
router for a stable connection address. If DHCP changes the address, restart
`wayvnc` and use the new address. No router port forwarding is needed.

Check the service with `systemctl --user status wayvnc` or
`journalctl --user -u wayvnc`. Stop sharing with `systemctl --user stop wayvnc`;
it starts again at the next Hyprland login.

## Virtualbox setup

- System -> Motherboard -> Enable EFI
- System -> Processor -> Enable PAE
- Display -> Graphics Controller -> VBoxVGA
- Storage -> Controller: SATA -> Use Host I/O Cache

## Cheatsheet
### Nix

* Install a package: `nix-env -i packageName`
* List all available packages: `nix-env -qa` (take a while to run, best of dumping this and grepping the listing)


### NixOS

* Configuration files: `host-*.nix`, `common.nix`, `packages-*.nix`
* Rebuild system: `./build.sh <host> switch`
