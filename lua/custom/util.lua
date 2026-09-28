-- ===================================================
-- Helper functions for github string and python path
-- ===================================================
local M = {}

---@param repo string
---@return string
function M.gh(repo) return 'https://github.com/' .. repo end

---@return string
function M.get_python_path()
  if vim.env.VIRTUAL_ENV then return vim.env.VIRTUAL_ENV .. '/bin/python' end
  if vim.env.CONDA_PREFIX then return vim.env.CONDA_PREFIX .. '/bin/python' end
  local p = vim.fn.exepath 'python3'
  return p ~= '' and p or 'python'
end

return M
