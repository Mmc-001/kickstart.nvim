-- ============================================================
-- UI / CORE UX PLUGINS
-- guess-indent, which-key, colorscheme, todo-comments, lualine
-- ============================================================

local gh = require('custom.util').gh
do
  -- Useful plugin to show you pending keybinds.
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    -- Delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  -- [[ Colorscheme ]]
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command under that to load whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  vim.pack.add { gh 'folke/tokyonight.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('tokyonight').setup {
    styles = {
      comments = { italic = false }, -- Disable italics in comments
    },
  }

  -- vim.pack.add { gh 'Mofiqul/vscode.nvim' }
  -- require('vscode').setup {
  --   transparent = true,
  --   italic_comments = false,
  -- }

  -- vim.pack.add { gh 'bluz71/vim-nightfly-colors' }
  -- require('vim-nightfly-colors').setup()

  -- Load the colorscheme here.
  -- Like many other themes, this one has different styles, and you could load
  -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  vim.cmd.colorscheme 'tokyonight-night'
  -- vim.cmd.colorscheme 'default' -- Default colorscheme, no extra plugin needed
  -- vim.cmd.colorscheme 'vscode' -- VS Code colorscheme
  -- vim.cmd.colorscheme 'nightfly'

  -- Highlight todo, notes, etc in comments
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup {
    signs = true, -- show icons in the signs column
  }

  -- Lualine setup
  vim.pack.add { gh 'nvim-lualine/lualine.nvim' }
  require('lualine').setup {
    options = {
      -- theme = 'ayu',
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { 'filename' },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  }
end
