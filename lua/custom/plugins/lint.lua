-- External linters run on entry, save, and leaving insert mode.
local gh = require('custom.util').gh

vim.pack.add { gh 'mfussenegger/nvim-lint' }

local lint = require 'lint'
lint.linters_by_ft = {
  markdown = { 'markdownlint' },
  dockerfile = { 'hadolint' },
  yaml = { 'yamllint' },
  sh = { 'shellcheck' },
  bash = { 'shellcheck' },
}
lint.linters.markdownlint.args = { '--disable', 'MD013', '--stdin' }

-- Assignment replaces defaults; merge into this table if another plugin adds linters.
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({
  'BufEnter',
  'BufWritePost',
  'InsertLeave',
}, {
  group = lint_augroup,
  callback = function()
    -- Skip read-only buffers such as LSP documentation popups.
    if vim.bo.modifiable then lint.try_lint() end
  end,
})
