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
