-- Remove plugins no longer active in the configuration from the pack state.
vim.pack.del(vim.iter(vim.pack.get()):filter(function(p) return not p.active end):map(function(p) return p.spec.name end):totable())
