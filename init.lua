-- TODO: comment for clarity and decoration
vim.loader.enable()

local modules = {
  'custom.options',
  'custom.keymaps',
  'custom.pack',
  'custom.plugins.editor',
  'custom.plugins.ui',
  'custom.plugins.git',
  'custom.plugins.navigation',
  'custom.plugins.lsp',
  'custom.plugins.format',
  'custom.plugins.completion',
  'custom.plugins.treesitter',
  'custom.plugins.lint',
  'custom.plugins.debug',
  'custom.plugins.latex',
}

for _, m in ipairs(modules) do
  local ok, err = pcall(require, m)
  if not ok then vim.notify(('Failed to load %s:\n%s'):format(m, err), vim.log.levels.ERROR) end
end
