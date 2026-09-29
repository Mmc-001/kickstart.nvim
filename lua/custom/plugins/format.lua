-- ============================================================
-- FORMATTING
-- conform.nvim setup and keymap
-- ============================================================

local gh = require('custom.util').gh

do
  -- [[ Formatting ]]
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- You can specify filetypes to autoformat on save here:
      local enabled_filetypes = {
        python = true,
        c = true,
        cpp = true,
        lua = true,
        dockerfile = true,
        yaml = true,
        tex = true,
      }
      if enabled_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      else
        return nil
      end
    end,
    default_format_opts = {
      lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
    },
    -- You can also specify external formatters in here.
    formatters_by_ft = {
      -- Python
      python = { 'ruff_format' },

      -- C/CPP
      c = { 'clang_format' },
      cpp = { 'clang_format' },

      -- Lua
      lua = { 'stylua' },

      -- LaTeX
      tex = { 'latexindent' },
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
end
