-- Open links correctly on wsl
vim.g.netrw_browsex_viewer="cmd.exe /C start"

-- Vimwiki
-- Change syntax to markdown and specify extension
vim.g.vimwiki_list = {{
  path= '/home/jonas/notes/vimwiki/',
  syntax= 'markdown',
  ext= '.md'
}}

-- Get common file
vim.cmd('source /etc/nixos/dotfiles/nvim/init-cmn.lua')
