-- Core editor options. Leaders must be set before mappings and plugins load.
do
  -- See `:help mapleader` and `:help maplocalleader`.
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Set false when the terminal does not use a Nerd Font.
  vim.g.have_nerd_font = true

  -- `vim.o` sets global options; `vim.opt` is convenient for list-like options.

  vim.o.number = true
  vim.o.relativenumber = true

  vim.o.mouse = 'a'

  vim.o.showmode = false

  -- Delay clipboard setup because provider discovery can slow startup.
  -- Remove this if Neovim should not share the OS clipboard.
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  vim.o.breakindent = true

  vim.o.winborder = 'rounded'

  vim.o.undofile = true

  vim.o.ignorecase = true
  vim.o.smartcase = true

  vim.o.signcolumn = 'yes'

  vim.o.updatetime = 250

  vim.o.timeoutlen = 300

  vim.o.splitright = true
  vim.o.splitbelow = true

  vim.o.tabstop = 4
  vim.o.softtabstop = 4
  vim.o.shiftwidth = 4
  vim.o.expandtab = true

  -- Show tabs, trailing spaces, and non-breaking spaces. See `:help listchars`.
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  vim.o.inccommand = 'split'

  vim.o.cursorline = true

  vim.o.scrolloff = 8

  -- Ask before commands such as `:q` would discard unsaved changes.
  vim.o.confirm = true
end

-- Docker Compose files: route to docker_language_server (yamlls excludes this filetype)
vim.filetype.add {
  filename = {
    ['compose.yaml'] = 'yaml.docker-compose',
    ['compose.yml'] = 'yaml.docker-compose',
    ['docker-compose.yaml'] = 'yaml.docker-compose',
    ['docker-compose.yml'] = 'yaml.docker-compose',
  },
  pattern = {
    ['compose%..+%.ya?ml'] = 'yaml.docker-compose',
    ['docker%-compose%..+%.ya?ml'] = 'yaml.docker-compose',
  },
}
