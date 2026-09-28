-- ============================================================
-- LATEX
-- VimTeX editing / compilation / SyncTeX
-- ============================================================

local gh = require('custom.util').gh

do
  vim.pack.add {
    gh 'lervag/vimtex',
  }

  vim.g.vimtex_view_method = 'skim'

  vim.g.vimtex_compiler_method = 'latexmk'

  vim.g.vimtex_compiler_latexmk = {
    options = {
      '-pdf',
      '-interaction=nonstopmode',
      '-synctex=1',
      '-file-line-error',
    },
  }

  vim.g.vimtex_quickfix_mode = 0
end
