-- UI feedback: key discovery, messages, theme, TODO markers, and statusline.

local gh = require('custom.util').gh
do
  -- Show available key sequences after a prefix such as `<leader>`.
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    preset = 'modern',
    delay = 250,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
      { '<leader>w', group = '[W]hitespace' },
      { '<leader>r', group = '[R]emove' },
    },
  }

  -- Replace noisy command/LSP message popups with a compact UI.

  vim.pack.add {
    gh 'MunifTanjim/nui.nvim',
    gh 'rcarriga/nvim-notify',
    gh 'folke/noice.nvim',
  }
  ---@diagnostic disable-next-line: missing-fields
  require('notify').setup { render = 'minimal' }
  require('noice').setup {
    lsp = {
      -- Use Treesitter to render markdown in LSP and completion documentation.
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
      signature = { enabled = false },
      progress = { enabled = false },
    },
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = false, -- long messages will be sent to a split
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
  }

  -- [[ Colorscheme ]]
  vim.pack.add { gh 'craftzdog/solarized-osaka.nvim' }
  require('solarized-osaka').setup {
    style = 'vivid',
    lualine_bold = true,
  }

  -- Load the colorscheme here.
  -- Like many other themes, this one has different styles, and you could load
  -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  vim.cmd.colorscheme 'solarized-osaka'

  -- Highlight TODO/FIXME-style markers in comments.
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup {
    signs = true, -- show icons in the signs column
  }

  -- Keep the statusline focused on navigation and diagnostics.
  vim.pack.add { gh 'nvim-lualine/lualine.nvim' }
  require('lualine').setup {
    options = {
      -- theme = 'powerline',
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff' },
      lualine_c = { 'diagnostics', 'filename' },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  }
end
