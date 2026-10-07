-- Editing helpers: textobjects, surroundings, comments, indentation, and CSV.

local gh = require('custom.util').gh

do
  -- Detect indentation from the current buffer.
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- mini.nvim supplies several small, independent editing modules.
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- Icons are optional; the compatibility shim supports plugins expecting devicons.
  if vim.g.have_nerd_font then
    require('mini.icons').setup()
    -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
    MiniIcons.mock_nvim_web_devicons()
  end

  -- Better around/inside textobjects; `aN`/`iN` avoid Neovim's TS selection keys.
  require('mini.ai').setup {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
    mappings = {
      around_next = 'aN',
      inside_next = 'iN',
    },
    n_lines = 500,
  }

  -- Add, delete, or replace brackets and quotes around text.
  require('mini.surround').setup()

  require('mini.operators').setup { exchange = { prefix = 'gX' }, replace = { prefix = 'g/' } }
  require('mini.splitjoin').setup()

  require('mini.comment').setup() -- gcc / gc — commenting, zero extra dependency

  require('mini.pairs').setup() -- lightweight automatic pairs

  require('mini.jump2d').setup()

  -- Show indentation guides, including on blank lines.
  vim.pack.add { gh 'lukas-reineke/indent-blankline.nvim' }
  require('ibl').setup {}

  require('mini.trailspace').setup()

  -- Configure CSV/TSV columns only when such a buffer is opened.
  vim.pack.add { gh 'hat0uma/csvview.nvim' }
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'csv', 'tsv' },
    once = true,
    callback = function()
      require('csvview').setup {
        view = {
          display_mode = 'border',
        },
        keymaps = {
          jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
          jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },

          jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
          jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
        },
      }
    end,
  })

  -- Char/line counter
  vim.pack.add { gh 'tzhouhc/virt-counter.nvim' }
  require('virt-counter').setup {
    preset = 'pill',
    pos = 'right_align',
    highlight_group = 'TodoBgTODO',
    button = {
      left = '',
      right = '',
      edge_highlight_group = 'TodoFgTODO', -- workaround to show an uninverted colorscheme for the edges
    },
  }

  vim.keymap.set('n', '<leader>wt', MiniTrailspace.trim, { desc = 'Trailing [W]hitespace [T]rim' })
end
