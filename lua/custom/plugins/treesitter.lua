-- Treesitter parser installation plus syntax highlighting and indentation.

local gh = require('custom.util').gh

do
  -- Parsers are installed on demand for supported filetypes.
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }
  if vim.fn.executable 'tree-sitter' == 0 then vim.notify('nvim-treesitter: tree-sitter-cli not found; parser installs will fail', vim.log.levels.WARN) end

  -- Install the languages used most often in this configuration.
  local parsers = {
    'bash',
    'bibtex',
    'c',
    'cmake',
    'cpp',
    'diff',
    'dockerfile',
    'html',
    'json',
    -- LaTeX is handled by VimTeX/texlab.
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'regex',
    'vim',
    'vimdoc',
    'yaml',
    'toml',
    'make',
    'gitcommit',
    'gitignore',
    'git_config',
    'ini',
    'xml',
    'doxygen',
  }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Load the parser if it is available locally.
    if not vim.treesitter.language.add(language) then return end

    -- Installation is asynchronous, so the buffer may have disappeared.
    if not vim.api.nvim_buf_is_valid(buf) then return end

    vim.treesitter.start(buf, language)

    -- Folds remain on Vim's default behavior until these options are enabled.
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- Use Treesitter indentation only where the language provides an indent query.
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      if filetype == 'tex' or filetype == 'plaintex' then return end

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Attach immediately when the parser is already installed.
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- Install a known parser on demand, then attach it to this buffer.
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- A system or third-party parser may still be available.
        treesitter_try_attach(buf, language)
      end
    end,
  })
end
