# My NIXOS configurations

## Relevant commands:

### Home-manager
- `home-manager switch` - Build new generation and switch to it
- `nix-env --list-generations` - List generations
- `nix-collect-garbage --delete-old` - Delete old generations
- `nix-collect-garbage --delete-generations 1 2 3` - Delete sesific generations
- 

### Nixos configuration
- `nixos-rebuild switch` - Build new generation and switch to it
- `nixos-rebuild list-generations` - List generations
- `sudo nix-collect-garbage --delete-old` - Delete old generations
