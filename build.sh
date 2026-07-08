#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get available hosts dynamically
get_hosts() {
    for f in "$SCRIPT_DIR"/host-*.nix; do
        basename "$f" .nix | sed 's/^host-//'
    done
}

# Show usage
usage() {
    echo "Usage: $0 <host> <command> [options]"
    echo ""
    echo "Available hosts:"
    for host in $(get_hosts); do
        echo "  - $host"
    done
    echo ""
    echo "Commands: switch, boot, test, build, dry-build, dry-activate"
    echo ""
    echo "Examples:"
    echo "  $0 laptop switch"
    echo "  $0 minipc build"
    echo "  $0 wsl dry-build"
    exit 1
}

# Check arguments
if [[ $# -lt 2 ]]; then
    usage
fi

HOST="$1"
COMMAND="$2"
shift 2

declare -A FLAKE_HOST_MAP=(
    [laptop]=matebook
    [minipc]=minipc
    [wsl]=nixos-wsl
)

HOST_FILE="$SCRIPT_DIR/host-${HOST}.nix"

# Validate host exists
if [[ ! -f "$HOST_FILE" ]]; then
    echo "Error: Unknown host '$HOST'"
    echo ""
    echo "Available hosts:"
    for host in $(get_hosts); do
        echo "  - $host"
    done
    exit 1
fi

# Validate command
case "$COMMAND" in
    switch|boot|test|build|dry-build|dry-activate)
        ;;
    *)
        echo "Error: Unknown command '$COMMAND'"
        echo "Valid commands: switch, boot, test, build, dry-build, dry-activate"
        exit 1
        ;;
esac

FLAKE_HOST="${FLAKE_HOST_MAP[$HOST]:-$HOST}"
CURRENT_HOST="$(hostname)"

has_target_host=false
for arg in "$@"; do
    if [[ "$arg" == "--target-host" || "$arg" == --target-host=* ]]; then
        has_target_host=true
        break
    fi
done

case "$COMMAND" in
    switch|boot|test|dry-activate)
        if [[ "$has_target_host" == false && "$CURRENT_HOST" != "$HOST" && "$CURRENT_HOST" != "$FLAKE_HOST" ]]; then
            echo "Error: refusing to run '$COMMAND' for host '$HOST' on local machine '$CURRENT_HOST'."
            echo ""
            echo "Use '$0 $HOST build' to build only, or deploy remotely with:"
            echo "  $0 $HOST $COMMAND --target-host elias@$FLAKE_HOST --use-remote-sudo"
            exit 1
        fi
        ;;
esac

NIX_CACHE_ARGS=(
    --accept-flake-config
    --option extra-substituters https://cache.numtide.com
    --option extra-trusted-public-keys niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=
)

BUILD_LIMIT_ARGS=()
if [[ "$HOST" == "laptop" ]]; then
    BUILD_LIMIT_ARGS=(
        --max-jobs "${NIX_MAX_JOBS:-1}"
        --cores "${NIX_CORES:-2}"
    )
fi

echo "Building '$HOST' with command '$COMMAND'..."
REBUILD_CMD=(nixos-rebuild "$COMMAND" --flake "path:$SCRIPT_DIR#$FLAKE_HOST" "${NIX_CACHE_ARGS[@]}" "${BUILD_LIMIT_ARGS[@]}" "$@")

if [[ "$has_target_host" == true ]]; then
    "${REBUILD_CMD[@]}"
else
    sudo "${REBUILD_CMD[@]}"
fi
