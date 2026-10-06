-- Small shared helpers used by plugin modules.
local M = {}

---@param repo string
---@return string
function M.gh(repo) return 'https://github.com/' .. repo end

---@return string
function M.get_python_path()
  -- Prefer the active environment so LSP and DAP use the same interpreter.
  if vim.env.VIRTUAL_ENV then return vim.env.VIRTUAL_ENV .. '/bin/python' end
  if vim.env.CONDA_PREFIX then return vim.env.CONDA_PREFIX .. '/bin/python' end
  local p = vim.fn.exepath 'python3'
  return p ~= '' and p or 'python'
end

return M
