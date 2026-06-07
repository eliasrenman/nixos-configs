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

echo "Building '$HOST' with command '$COMMAND'..."
sudo nixos-rebuild "$COMMAND" --flake "path:$SCRIPT_DIR#$FLAKE_HOST" "$@"
