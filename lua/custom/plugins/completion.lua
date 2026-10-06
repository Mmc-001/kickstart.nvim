-- Completion sources, snippet expansion, and signature help.

local gh = require('custom.util').gh

do
  -- friendly-snippets supplies reusable snippets for many languages.
  vim.pack.add { gh 'rafamadriz/friendly-snippets' }

  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      -- Built-in completion-like mappings; see `:help ins-completion`.
      preset = 'default',
    },

    appearance = {
      -- Match icon spacing to the Nerd Font variant used by the terminal.
      nerd_font_variant = 'mono',
    },

    completion = {
      -- Documentation stays manual via `<C-space>` to reduce visual noise.
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = {
        'lsp',
        'path',
        'snippets',
        'buffer',
      },
      per_filetype = { lua = {
        'lazydev',
        'lsp',
        'path',
        'snippets',
        'buffer',
      } },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },

    snippets = { preset = 'default' },

    -- Prefer the Rust matcher when available, with a warning and Lua fallback.
    fuzzy = { implementation = 'prefer_rust_with_warning' },

    signature = { enabled = true },
  }
end
