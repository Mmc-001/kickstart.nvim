-- LaTeX editing, latexmk compilation, PDF viewing, and semantic diagnostics.

local util = require 'custom.util'

vim.pack.add {
  util.gh 'lervag/vimtex',
}

-- VimTeX handles compilation and SyncTeX; macOS uses Skim, other systems Zathura.
vim.g.vimtex_view_method = vim.fn.has 'mac' == 1 and 'skim' or 'zathura'
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1
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

-- Uncomment to disable VimTeX's mappings if they conflict with yours.
-- vim.g.vimtex_mappings_enabled = 0

-- texlab provides semantic features; VimTeX remains responsible for building.
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
    },
  },
})

-- LTeX+ adds grammar and spelling diagnostics on save.
vim.lsp.config('ltex_plus', {
  filetypes = { 'tex', 'plaintex' },

  settings = {
    ltex = {
      language = 'en-US',
      diagnosticSeverity = 'information',
      checkFrequency = 'save',
      dictionary = {
        ['en-US'] = { --[[ project jargon ]]
        },
      },
    },
  },
})

vim.lsp.enable {
  'texlab',
  'ltex_plus',
}
