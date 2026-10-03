-- ============================================================
-- FORMATTING
-- conform.nvim setup and keymap
-- ============================================================

local gh = require('custom.util').gh

do
  -- [[ Formatting ]]
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = true,
    format_on_save = function(bufnr)
      local timeouts = { python = 500, c = 500, cpp = 500, lua = 500, dockerfile = 500, yaml = 500, tex = 3000 }
      local t = timeouts[vim.bo[bufnr].filetype]
      if t then return { timeout_ms = t } end
    end,
    default_format_opts = {
      lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
    },
    -- You can also specify external formatters in here.
    formatters_by_ft = {
      -- Python
      python = { 'ruff_organize_imports', 'ruff_format' },

      -- C/CPP
      c = { 'clang_format' },
      cpp = { 'clang_format' },

      -- Lua
      lua = { 'stylua' },

      -- LaTeX
      tex = { 'latexindent' },

      -- YAML
      yaml = { 'yamlfmt' },
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
end
