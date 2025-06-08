-- Ledger addin config
vim.g.ledger_date_format = '%Y-%m-%d'

-- Kolonne som . i beløp skal alignes med
vim.g.ledger_align_at = 45
vim.g.ledger_default_commodity = 'kr'

-- kr kommer etter beløp
vim.g.ledger_commodity_before = 0

-- Fussy account and details first on search
vim.g.ledger_detailed_first = 1
vim.g.ledger_fuzzy_account_completion = 1

-- ledger autocomplete
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "ledger",
  callback = function()
    vim.keymap.set('i', '<Tab>', function()
      local keys = vim.api.nvim_replace_termcodes(
        "<C-r>=ledger#autocomplete_and_align()<CR>",
        true, true, true
      )
      return vim.fn.pumvisible() == 1
        and '<Tab>' -- If popup is open select next item
        or vim.api.nvim_feedkeys(keys, "i", false) -- If not, autocomplete_and_align
    end, { silent = true, buffer = true })
  end
})

-- Vimwiki
-- Change syntax to markdown and specify extension
-- This has to come before loading the plugin
vim.g.vimwiki_list = {{
  path = '/home/jonas/Nextcloud/Notes/vimwiki/',
  syntax = 'markdown',
  ext = '.md'
}}

-- Get common file
vim.cmd('source /etc/nixos/dotfiles/nvim/init-cmn.lua')
