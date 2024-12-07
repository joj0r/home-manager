{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
  
    configure = {
      defaultEditor = true;
      vimAlias = true;
      customRC = ''
        set nocompatible
  
        " Tab-size:
        set tabstop=2
        set shiftwidth=2
        set expandtab "(If you want spaces instead of tabs)
        
        set number
        set relativenumber
        set syntax
      '';
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [ vim-lastplace vim-nix ]; 
        opt = [];
      };
    };
  };
}
