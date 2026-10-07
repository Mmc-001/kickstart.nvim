# Neovim Configuration

Personal Neovim configuration, originally based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and extensively customized and modularized.

Focused on Python, C/C++, CERN ROOT, LaTeX, shell scripting, Docker, and general development.

## Structure

```text
.
├── init.lua
└── lua/
    └── custom/
        ├── options.lua
        ├── keymaps.lua
        ├── autocmds.lua
        ├── pack.lua
        ├── util.lua
        └── plugins/
            ├── lsp.lua
            ├── navigation.lua
            ├── debug.lua
            ├── ui.lua
            └── ...
```

## Installation

```bash
git clone https://github.com/Mmc-001/kickstart.nvim.git ~/.config/nvim
nvim
```

Required system tools include Neovim, Git, a C/C++ toolchain, Python, `ripgrep`, and `fd`. Additional language-specific tools are managed through the configuration and Mason where applicable.

## Tooling

- Native Neovim LSP + Mason
- nvim-cmp
- Treesitter
- Telescope
- Conform
- nvim-lint
- nvim-dap
- VimTeX
- Gitsigns
- selected `mini.nvim` modules

Configuration is organized under `lua/custom/`; plugin-specific configuration belongs in `lua/custom/plugins/`.
