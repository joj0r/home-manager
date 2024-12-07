-- Get file for local adjustments
vim.cmd('source ~/dotfiles/local_arch.lua')

-- lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Auto-install lazy.nvim if not present
if not vim.uv.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  print('Done.')
end

vim.opt.rtp:prepend(lazypath)

-- Install plugins
require('lazy').setup({
  -- LSP and autocomplete
  { 'VonHeikemen/lsp-zero.nvim',        branch = 'v4.x' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/nvim-cmp' },
  -- ledger
  { 'ledger/vim-ledger' },
  -- Wiki and Task
  { 'vimwiki/vimwiki' },
  { 'tools-life/taskwiki' },
  { 'blindFS/vim-taskwarrior' },
  -- Visual and interaction
  { 'folke/tokyonight.nvim' },
  { 'Yggdroot/indentLine' },
  { 'morhetz/gruvbox' },
  -- {'christoomey/vim-tmux-navigator'},
  {
    'MunsMan/kitty-navigator.nvim',
    build = {
      "cp navigate_kitty.py ~/.config/kitty",
      "cp pass_keys.py ~/.config/kitty",
    },
    keys = {
      {"<C-h>", function()require("kitty-navigator").navigateLeft()end, desc = "Move left a Split", mode = {"n"}},
      {"<C-j>", function()require("kitty-navigator").navigateDown()end, desc = "Move down a Split", mode = {"n"}},
      {"<C-k>", function()require("kitty-navigator").navigateUp()end, desc = "Move up a Split", mode = {"n"}},
      {"<C-l>", function()require("kitty-navigator").navigateRight()end, desc = "Move right a Split", mode = {"n"}},
    },
  },
  { 'preservim/nerdtree' },
  { 'AndrewRadev/splitjoin.vim' },
  { 'tpope/vim-surround' },

  -- Telescope
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim', tag = '0.1.8' },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    }
  },
  -- Git
  { 'tpope/vim-fugitive' },
})

-- Disable tmux navigator when zooming the Vim pane
vim.g.tmux_navigator_disable_when_zoomed = 1

-- Set numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Set tabwidth to 2 and spaces instead of numbers
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- From thePrimeagen
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.scrolloff = 8

-- Set leader to spacebar
vim.g.mapleader = " "

-- Search sould not be case sensitive
vim.o.ignorecase = true

-- Vim-ledger
-- Fussy account and details first on search
vim.g.ledger_detailed_first = 1
vim.g.ledger_fuzzy_account_completion = 1

-- Vimwiki
vim.g.vimwiki_global_ext = 0
vim.keymap.set('n', '<leader>ww', '<cmd>:VimwikiIndex<CR>')

-- Disable indentline for Wiki and MD files
vim.api.nvim_create_autocmd({ "Filetype" }, {
  pattern = { "vimwiki", "markdown", "ledger" },
  callback = function()
    vim.g.indentLine_enabled = 0
  end
})

-- splitjoin mapping
vim.g.splitjoin_split_mapping = ''
vim.g.splitjoin_join_mapping = ''
vim.keymap.set('n', '<leader>j', '<cmd>:SplitjoinJoin<CR>')
vim.keymap.set('n', '<leader>s', '<cmd>:SplitjoinSplit<CR>')

--- Nerdtree remaping
vim.keymap.set('n', '<leader>n', '<cmd>:NERDTreeFocus<CR>')
vim.keymap.set('n', '<C-n>', '<cmd>:NERDTree<CR>')
vim.keymap.set('n', '<C-t>', '<cmd>:NERDTreeToggle<CR>')
vim.keymap.set('n', '<C-f>', '<cmd>:NERDTreeFind<CR>')

-- Telescope remapping
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Colorscheme
vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')

require('lualine').setup {
  options = {
    theme = 'tokyonight'
  }
}

-- LSP configurations ---
--
-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- Mason for autoinstall of LSP servers
require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

-- Auto completion settings
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
  mapping = cmp.mapping.preset.insert({
    -- Navigate between completion items
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),

    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },

    --Tab completion
    ['<Tab>'] = function(fallback)
      if vim.bo.filetype == "ledger" then
        fallback()
      end
      if not cmp.select_next_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,

    ['<S-Tab>'] = function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
})
