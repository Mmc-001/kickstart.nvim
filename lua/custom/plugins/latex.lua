-- ============================================================
-- LATEX
-- VimTeX editing / compilation / SyncTeX
-- ============================================================

local util = require 'custom.util'

vim.pack.add {
  util.gh 'lervag/vimtex',
}

-- VimTeX: compilation, PDF viewing, inverse search, etc.
vim.g.vimtex_view_method = 'skim'
vim.g.vimtex_compiler_method = 'latexmk'

vim.g.vimtex_compiler_latexmk = {
  build_dir = '',
  callback = 1,
  continuous = 1,
  executable = 'latexmk',
  options = {
    '-pdf',
    '-interaction=nonstopmode',
    '-synctex=1',
    '-file-line-error',
  },
}

vim.g.vimtex_quickfix_mode = 0

-- Avoid VimTeX mappings overriding your own <localleader> mappings.
-- vim.g.vimtex_mappings_enabled = 0

-- texlab: semantic LaTeX LSP only.
vim.lsp.config('texlab', {
  filetypes = { 'tex', 'plaintex', 'bib' },

  settings = {
    texlab = {
      build = {
        onSave = false,
        forwardSearchAfter = false,
      },

      diagnosticsDelay = 300,

      chktex = {
        onOpenAndSave = true,
        onEdit = true,
        additionalArgs = {
          '-n24',
          '-n42',
        },
      },

      formatterLineLength = 80,
    },
  },
})

-- LTeX+: grammar/spelling diagnostics for LaTeX and Markdown.
vim.lsp.config('ltex_plus', {
  filetypes = { 'tex', 'plaintex' },

  settings = {
    ltex = {
      language = 'en-US',
      diagnosticSeverity = 'information',
      checkFrequency = 'save',
    },
  },
})

vim.lsp.enable {
  'texlab',
  'ltex_plus',
}
