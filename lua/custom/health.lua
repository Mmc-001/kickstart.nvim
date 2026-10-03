local M = {}

function M.check()
  vim.health.start 'custom: external dependencies'
  if vim.fn.has 'nvim-0.12' == 0 then vim.health.error 'Neovim >= 0.12 required (vim.pack)' end

  for _, bin in ipairs { 'git', 'make', 'cc', 'curl', 'tar', 'rg', 'latexmk', 'latexindent', 'chktex' } do
    if vim.fn.executable(bin) == 1 then
      vim.health.ok(bin)
    else
      vim.health.warn(bin .. ' not in PATH')
    end
  end

  if vim.fn.executable 'tree-sitter' == 1 then
    local out = vim.fn.system { 'tree-sitter', '--version' }
    local ver = out:match '(%d+%.%d+%.%d+)'
    if vim.v.shell_error ~= 0 or not ver then
      vim.health.warn 'tree-sitter --version unparseable'
    elseif vim.version.lt(ver, '0.26.1') then
      vim.health.error('tree-sitter ' .. ver .. ' < 0.26.1; parser installs will fail')
    else
      vim.health.ok('tree-sitter ' .. ver)
    end
  else
    vim.health.warn 'tree-sitter not in PATH'
  end
end

return M
