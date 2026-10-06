-- Global keymaps, diagnostics, and small editor-wide autocmds.
do
  -- Clear search highlights without changing the cursor position.
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostics are quiet while typing and open in a float after jumps.
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    virtual_text = {
      spacing = 2,
      source = 'if_many',
    },
    virtual_lines = false,

    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Easier terminal-mode escape; <C-\><C-n> remains the fallback.
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Encourage hjkl navigation without disabling arrows in insert mode.
  vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!"<CR>')
  vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!"<CR>')
  vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!"<CR>')
  vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!"<CR>')

  -- Use Ctrl-hjkl to move between split windows. See `:help wincmd`.
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Some terminals cannot distinguish these shifted control keys.

  -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
  -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
  -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
  -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

  -- Briefly highlight text after yanking.
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })
end
