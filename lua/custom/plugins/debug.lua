-- Debug Adapter Protocol setup for Python and C/C++.
-- Loaded after UIEnter so debugger plugins do not delay normal startup.
local util = require 'custom.util'
vim.pack.add {
  util.gh 'mfussenegger/nvim-dap',
  util.gh 'rcarriga/nvim-dap-ui',
  util.gh 'nvim-neotest/nvim-nio',
  util.gh 'mason-org/mason.nvim',
  util.gh 'jay-babu/mason-nvim-dap.nvim',
}

-- These maps are global; add language-specific maps in the configurations below.
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
-- Open the UI to inspect the current or last debugging session.
vim.keymap.set('n', '<F7>', function() require('dapui').toggle() end, { desc = 'Debug: See last session result.' })

local dap = require 'dap'

-- Python
dap.adapters.python = {
  type = 'executable',
  command = vim.fn.stdpath 'data' .. '/mason/bin/debugpy-adapter',
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    python = function() return util.get_python_path(vim.fn.getcwd()) end,
    console = 'integratedTerminal',
  },
}

-- C/C++
dap.adapters.codelldb = {
  type = 'executable',
  command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
}

dap.configurations.cpp = {
  {
    name = 'Launch executable',
    type = 'codelldb',
    request = 'launch',
    program = function() return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file') end,
    cwd = '${workspaceFolder}',
    args = function() return vim.split(vim.fn.input 'Args: ', ' ', { trimempty = true }) end,
    stopOnEntry = false,
  },
}

dap.configurations.c = dap.configurations.cpp

local dapui = require 'dapui'

require('mason-nvim-dap').setup {
  -- Install the adapters used by the configurations above.
  automatic_installation = true,

  ensure_installed = {
    'debugpy',
    'codelldb',
  },
}

-- DAP UI layout and controls.
---@diagnostic disable-next-line: missing-fields
dapui.setup {
  -- Plain characters keep the UI usable without a Nerd Font.
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  ---@diagnostic disable-next-line: missing-fields
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

-- Optional breakpoint highlight/sign customization:
-- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
-- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
-- local breakpoint_icons = vim.g.have_nerd_font
--     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
--   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
-- for type, icon in pairs(breakpoint_icons) do
--   local tp = 'Dap' .. type
--   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
--   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
-- end

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close
