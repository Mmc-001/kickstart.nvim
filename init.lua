-- Entry point: load core settings and plugin modules in dependency order.
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
  'custom.plugins.latex',
}
local function load(m)
  -- Keep one broken optional module from preventing the rest of the config from loading.
  local ok, err = xpcall(require, debug.traceback, m)
  if not ok then vim.notify(('Failed to load %s:\n%s'):format(m, err), vim.log.levels.ERROR) end
end

for _, m in ipairs(modules) do
  load(m)
end

vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    -- DAP is loaded after the first UI event so startup stays lighter.
    vim.schedule(function() load 'custom.plugins.debug' end)
  end,
})
