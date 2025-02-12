# NeoJulia
This repo contains config for turning nvim into a Julia IDE


# Neovim Julia IDE

A comprehensive Neovim configuration for Julia development, featuring integrated REPL, LSP support, and cell-based execution.

## Features

- Julia Language Server Protocol (LSP) integration
- Interactive REPL with clean output
- Cell-based code execution
- Syntax highlighting and code completion
- Git integration
- File explorer
- Beautiful UI with Tokyo Night theme

## Installation

### Prerequisites

1. Neovim (>= 0.8.0)
2. Julia (>= 1.6)
3. Git
4. Node.js (for LSP features)
5. A Nerd Font (for icons)

### Dependencies

Create a new file named `dependencies.jl` in your Julia environment and add:

```julia
# Project.toml will be created automatically
using Pkg

# Development tools
Pkg.add("LanguageServer")
Pkg.add("StaticLint")
Pkg.add("SymbolServer")

# Optional but recommended packages
Pkg.add("Revise")
Pkg.add("OhMyREPL")
Pkg.add("TestEnv")
```

### Plugin Dependencies

Make sure you have [vim-plug](https://github.com/junegunn/vim-plug) installed. The configuration will automatically install it if missing.

### Installation Steps

1. Backup your existing Neovim configuration:
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. Create new Neovim configuration directory:
```bash
mkdir -p ~/.config/nvim/lua
```

3. Copy the configuration files:
```bash
# Copy init.vim to ~/.config/nvim/init.vim
# Copy init.lua to ~/.config/nvim/lua/init.lua
```

4. Install plugins:
```bash
nvim +PlugInstall +qall
```

5. Install LSP servers:
```bash
nvim +MasonInstall
```

## Keybindings

### General Shortcuts

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<Space>` | Normal | Leader key |
| `<C-h/j/k/l>` | Normal | Window navigation |
| `<TAB>` | Normal | Next buffer |
| `<S-TAB>` | Normal | Previous buffer |
| `<C-n>` | Normal | Toggle file explorer |
| `<C-\>` | Normal | Toggle terminal |

### File Finding

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Live grep |
| `<leader>fb` | Normal | Find buffers |

### Julia REPL Integration

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>jl` | Normal | Toggle Julia REPL |
| `<F5>` | Normal | Run entire file |
| `<F6>` | Normal | Run current line |
| `<F7>` | Normal | Run current cell |
| `<F8>` | Visual | Run selected code |
| `[c` | Normal | Jump to previous cell |
| `]c` | Normal | Jump to next cell |

### Git Integration

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>gs` | Normal | Git status |
| `<leader>gd` | Normal | Git diff |

## Cell-Based Execution

Cells are defined by `#%%` markers in your Julia files. Example:

```julia
#%%
# This is cell 1
println("Hello")

#%%
# This is cell 2
println("World")
```

## Customization

### Theme
The configuration uses Tokyo Night theme by default. To change themes:

1. Install your preferred theme plugin
2. Modify the `colorscheme` line in `init.vim`
3. Update the `lualine` theme in `init.lua`

### REPL Appearance
The REPL is configured for clean output with:
- Simplified prompt
- Hidden line numbers
- No sign column
- Customizable size (default: 80 columns)

## Troubleshooting

### Common Issues

1. **LSP not working:**
   - Check if Julia Language Server is installed
   - Run `:LspInfo` in Neovim
   - Ensure Julia is in your PATH

2. **Missing icons:**
   - Install a Nerd Font
   - Configure your terminal to use the Nerd Font

3. **REPL not starting:**
   - Check if Julia is accessible from terminal
   - Verify ToggleTerm installation
   - Check Julia path in configuration

## Contributing

Feel free to submit issues and enhancement requests!

## Acknowledgments

- Neovim community
- Julia community
- Plugin authors and maintainers

## thanks to~
https://www.youtube.com/watch?v=GazrDjcdeG4 
This youtube video had great impact on this project

Also Clude made this go much easier!
