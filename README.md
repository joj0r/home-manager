# My NixOS configurations

Welcome to my personal NixOS setup. Started my NixOS journey 2024.12.01 by installing on my Micosoft Surface Go 2.
This is work in progress, and I still have lots of configuration left.

## Things to do

### To have a fully functional Surface
* [ ] Set up virtual keyboard to enable use without physical keyboard  #042f5b7d
* [ ] Set up HyprGrass with relevant programs etc.  #068791fd
* [ ] Configure media-keys to work with sound, screenbacklight and hyprsunset  #f1ca7129
* [ ] Configure hypridle to quicly and easily suspend  #a3bf6066
* [ ] Set up iio-hyprland for auto-rotating screen  #34bb2697
* [ ] Set up touch-friendly slides for volume, backlight and hyprsunset  #2458f4c0

### To be good enough to move to NixOS on my XPS-13
* [ ] Get autoopen kWallet to work for NextCloud client  #923f6dd1
* [ ] Configure LSP that works in Neovim  #44267c56

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
