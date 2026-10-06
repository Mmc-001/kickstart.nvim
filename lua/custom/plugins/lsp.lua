-- LSP attachment, buffer-local actions, server settings, and tool installation.
local util = require 'custom.util'
do
  -- [[ LSP Configuration ]]
  -- Useful status updates for LSP.
  vim.pack.add { util.gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  --  This function gets run when an LSP attaches to a particular buffer.
  --    That is to say, every time a new file is opened that is associated with
  --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --    function will be executed to configure the current buffer
  -- Configure maps and optional features per buffer when a server attaches.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      -- Keep LSP mappings buffer-local and give them a common which-key prefix.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- Declaration can point to a header or interface rather than an implementation.
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Highlight references after a short pause, and clear them when the cursor moves.
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.name == 'ltex_plus' then
        vim.diagnostic.config({ underline = true, virtual_text = false }, vim.lsp.diagnostic.get_namespace(client.id))
      end
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight' .. event.buf, { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach' .. event.buf, { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- Inlay hints are opt-in because they can make source code visually denser.
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- Server names here are also added to Mason's install list below.
  ---@type table<string, vim.lsp.Config>
  local servers = {
    -- C/C++
    clangd = { cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu', '--completion-style=detailed' } },

    -- Python
    basedpyright = {
      settings = {
        basedpyright = {
          disableOrganizeImports = true,
          disableTaggedHints = true,
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = 'openFilesOnly',
            typeCheckingMode = 'standard',
          },
        },
      },
      before_init = function(_, config) config.settings.python = { pythonPath = util.get_python_path(config.root_dir) } end,
    },
    ruff = {
      on_attach = function(client) client.server_capabilities.hoverProvider = false end, -- basedpyright owns hover
    },

    -- Dockerfiles, compose.yaml, docker-bake.hcl, etc.
    docker_language_server = {},

    -- YAML
    yamlls = {
      filetypes = { 'yaml', 'yaml.gitlab', 'yaml.helm-values' },
      settings = {
        yaml = {
          validate = true,
          hover = true,
          completion = true,
        },
      },
    },

    -- Shellscript
    bashls = {},

    -- JSON
    jsonls = {},

    -- Keep Lua formatting with conform.nvim rather than lua_ls.
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end
        local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
        client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
          runtime = { version = 'LuaJIT' },
          workspace = { checkThirdParty = false }, -- library removed; lazydev handles this now
        })
      end,
      settings = {},
    },
  }

  vim.pack.add {
    util.gh 'neovim/nvim-lspconfig',
    util.gh 'mason-org/mason.nvim',
    util.gh 'mason-org/mason-lspconfig.nvim',
    util.gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  -- Install servers and tools under Neovim's data directory.
  require('mason').setup {}

  -- Translate server names to Mason package names; enabling remains explicit below.
  require('mason-lspconfig').setup {
    automatic_enable = false, -- Change this to true if you want to automatically enable servers that are installed manually (e.g. via :Mason / :MasonInstall)
  }

  -- Add formatters, linters, and language tools not represented by `servers`.
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    -- You can add other tools here that you want Mason to install

    -- Markdown
    'markdownlint',

    -- Python
    'ruff',

    -- C / C++
    'clang-format',

    -- Docker
    'hadolint',

    -- YAML / Docker Compose
    'yamllint',

    -- Lua
    'stylua',

    -- LaTeX
    'texlab',
    'ltex-ls-plus',

    -- Shell
    'shellcheck',
    'shfmt',
  })

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  vim.pack.add { util.gh 'folke/lazydev.nvim' }
  require('lazydev').setup {
    library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } },
  }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end
