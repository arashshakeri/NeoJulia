-- ~/.config/nvim/lua/init.lua

-- Setup Mason
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    ensure_installed = { 
        "julials",    -- Julia
        "pyright",    -- Python
        "lua_ls",     -- Lua
        "jsonls",     -- JSON
    }
})

-- Setup Treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { "julia", "python", "lua", "vim", "json", "markdown" },
    highlight = {
        enable = true,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
    },
    indent = {
        enable = true
    },
}

-- Setup nvim-cmp with modified completion behavior
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Load friendly snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        -- Disable Enter key for completion confirmation
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        -- Modified Tab behavior
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    }),
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
})

-- Setup LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Julia LSP
require('lspconfig').julials.setup({
    capabilities = capabilities,
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        julia = {
            lint = {
                missingrefs = "all",
                iter = true,
                lazy = true,
                modname = true
            }
        }
    }
})

-- Setup nvim-tree
require("nvim-tree").setup({
    view = {
        width = 30,
    },
    filters = {
        dotfiles = false,
    },
    git = {
        enable = true,
        ignore = false,
    },
    renderer = {
        group_empty = true,
        highlight_git = true,
        icons = {
            show = {
                git = true,
                folder = true,
                file = true,
                folder_arrow = true,
            },
        },
    },
})

-- Setup lualine
require('lualine').setup({
    options = {
        theme = 'tokyonight',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
    },
})

-- Setup bufferline
require("bufferline").setup({
    options = {
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = false,
    }
})

-- Setup gitsigns
require('gitsigns').setup()

-- Setup Comment.nvim
require('Comment').setup()

-- Setup autopairs
require('nvim-autopairs').setup()

-- Setup which-key
require("which-key").setup()

-- Setup notify
vim.notify = require("notify")

-- Setup todo-comments
require("todo-comments").setup()

-- Setup indent-blankline (v3)
require("ibl").setup({
    indent = {
        char = "│",
    },
    scope = {
        enabled = true,
        show_start = true,
        show_end = false,
    },
})

-- Setup colorizer
require('colorizer').setup()

-- Enhanced Julia REPL setup with clean output
local Terminal = require('toggleterm.terminal').Terminal

-- Function to initialize Julia with custom startup commands
local function get_startup_commands()
    return [[
        # Custom startup to modify REPL output
        import REPL
        import Logging

        # Customize error display
        Base.error_color() = :red
        
        # Suppress version info and welcome message
        ENV["JULIA_NOVERSIONS"] = "yes"
        
        # Customize prompt
        function custom_prompt()
            return "julia> "
        end
        
        # Apply custom prompt
        Base.active_repl.interface.modes[1].prompt = custom_prompt()
        
        # Suppress additional output
        Core.eval(Main, :(have_shown_startup = true))
        
        # Clear startup messages
        println("\033[2J\033[H")
    ]]
end

-- Create a Julia REPL terminal with enhanced setup
local julia = Terminal:new({
    cmd = "julia",
    direction = "vertical",
    size = 80,
    hidden = true,
    on_open = function(term)
        -- Send startup commands when REPL opens
        vim.defer_fn(function()
            term:send(get_startup_commands())
        end, 100)
        
        -- Set up keymaps
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", "<C-\\><C-n>", {noremap = true, silent = true})
        
        -- Set up buffer-local options
        vim.api.nvim_buf_set_option(term.bufnr, 'signcolumn', 'no')
        vim.api.nvim_buf_set_option(term.bufnr, 'number', false)
        vim.api.nvim_buf_set_option(term.bufnr, 'relativenumber', false)
    end,
    on_exit = function(_)
        vim.cmd("stopinsert")
    end,
})

-- Function to clean and send code to Julia
local function send_to_julia(code)
    if not julia:is_open() then
        julia:open()
        -- Wait for REPL to initialize before sending code
        vim.defer_fn(function()
            julia:send(code)
            vim.cmd("wincmd p")  -- Return focus to previous window
        end, 200)  -- Increased delay for better stability
    else
        julia:send(code)
        vim.cmd("wincmd p")
    end
end

-- Function to get cell content
local function get_cell_content()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local start_line = current_line
    local end_line = current_line
    
    while start_line > 1 and not lines[start_line-1]:match("^#%%") do
        start_line = start_line - 1
    end
    
    while end_line < #lines and not lines[end_line+1]:match("^#%%") do
        end_line = end_line + 1
    end
    
    local cell_content = table.concat(vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false), "\n")
    return cell_content
end

-- Create global commands and mappings
vim.api.nvim_create_user_command('JuliaREPL', function() 
    if julia:is_open() then
        julia:close()
    else
        julia:open()
        vim.cmd("wincmd p")
    end
end, {})

-- Julia keybindings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "julia",
    callback = function()
        -- Run file
        vim.keymap.set("n", "<F5>", function()
            local file = vim.fn.expand('%:p')
            send_to_julia('include("' .. file .. '")')
        end, {buffer = true})
        
        -- Run line
        vim.keymap.set("n", "<F6>", function()
            local line = vim.api.nvim_get_current_line()
            send_to_julia(line)
        end, {buffer = true})
        
        -- Run cell
        vim.keymap.set("n", "<F7>", function()
            local cell_content = get_cell_content()
            send_to_julia(cell_content)
        end, {buffer = true})
        
        -- Run selection
        vim.keymap.set("v", "<F8>", function()
            local start_pos = vim.fn.getpos("'<")
            local end_pos = vim.fn.getpos("'>")
            local lines = vim.api.nvim_buf_get_lines(0, start_pos[2]-1, end_pos[2], false)
            local code = table.concat(lines, "\n")
            send_to_julia(code)
        end, {buffer = true})
    end
})

-- Additional Julia keybinding
vim.keymap.set("n", "<leader>jl", "<cmd>JuliaREPL<CR>", {noremap = true, silent = true})

-- Setup toggleterm
require("toggleterm").setup({
    -- Universal toggleterm settings
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    start_in_insert = true,
    persist_size = true,
    close_on_exit = true,
})
