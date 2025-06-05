# My NixOS configurations

Welcome to my personal NixOS setup. Started my NixOS journey 2024.12.01 by installing on my Micosoft Surface Go 2.
This is work in progress, and I still have lots of configuration left.

## Things to do

### To have a fully functional Surface
* [X] Set up virtual keyboard to enable use without physical keyboard  #df05845b
* [ ] Set up HyprGrass with relevant programs etc.  #bf09a4c0
* [ ] Configure media-keys to work with sound, screenbacklight and hyprsunset  #69e713f4
* [ ] Configure hypridle to quicly and easily suspend  #91964932
* [ ] Set up iio-hyprland for auto-rotating screen  #dace1d28
* [ ] Set up touch-friendly slides for volume, backlight and hyprsunset  #97862c87

## Installation
1. Boot from NixOS live USB. Connect to wifi and change keyboard layout
2. Install using [NixOS manual](https://nixos.org/manual/nixos/stable/#sec-installation-manual) and [ZFS on NixOS](https://nixos.wiki/wiki/ZFS)
```bash
fdisk /dev/nvme0n1 
# to create the following disks:
/dev/nvme0n1p1 1G EFI System
/dev/nvme0n1p2 Linux filesystem

# Create zfs pool
zpool create -O encryption=on -O keyformat=passphrase -O keylocation=prompt -O compression=lz4 -O mountpoint=none -O xattr=sa -O acltype=posixacl -o ashift=12 -o atime=off zpool /dev/nvme0n1p2

# Create datasets
zfs create -o mountpoint=legacy zpool/root
zfs create -o mountpoint=legacy zpool/home

# Create mountpoints and mount datasets
mkdir /mnt
mount -t zfs zpool/root /mnt
mkdir /mnt/home

mount -t zfs zpool/home /mnt/home

# Create fat-partiotion for boot
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```
3. Get config
```bash
git clone https://github.com/joj0r/home-manager.git ~/.config/

```
1. Edit configuration.nix:
  1. comment out bootloader config
  2. add `./config.nix` to imports
2. After install, configure
```bash
# Clone this repo with config files
git clone https://github.com/joj0r/home-manager.git ~/.config/

# Link configuration.nix (NB: Merge first)
ln -sf /home/jonas/.config/home-manager/configuration.nix /etc/nixos/configuration.nix

# Install home-manager standalone
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
nix-channel --update
nix-shell '<home-manger>' -A install

# Fetch pass database
git clone <pass-url> ~/.password-store

# Import gpg-keys
gpg --import /path/to/subkey
```

## Relevant commands:

### Home-manager
- `home-manager switch` - Build new generation and switch to it
- `nix-env --list-generations` - List generations
- `nix-collect-garbage --delete-old` - Delete old generations
- `nix-collect-garbage --delete-generations 1 2 3` - Delete sesific generations

### Nixos configuration
- `sudo nixos-rebuild switch` - Build new generation and switch to it
- `sudo nixos-rebuild list-generations` - List generations
- `sudo nix-collect-garbage --delete-old` - Delete old generations

### Nix-shell
- `nix-shell -p [packages to install]` - Run shell with temporaryliy installed packages
- `nix-collect-garbage` - Clean up after nix-shell
