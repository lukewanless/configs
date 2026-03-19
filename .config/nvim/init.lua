-- This comment ensures Neovim recognizes this as a Lua file
-- Make sure this file is saved as init.lua in ~/.config/nvim/

-- Check if running in Neovim environment
local has_nvim, vim = pcall(function() return vim end)
if not has_nvim then
    print("Error: This script must run inside Neovim")
    return
end

-- Set leader key first thing - MUST be before loading plugins
vim.g.mapleader = " " 
vim.g.maplocalleader = " "

-- Basic settings
vim.opt.termguicolors = true -- needed for bufferline
vim.opt.clipboard = "unnamedplus"

-- Install Lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_err_writeln("Failed to clone lazy.nvim: " .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins with Lazy.nvim
require("lazy").setup({
    -- LSP and related plugins
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim",
            "folke/neodev.nvim",
            "hrsh7th/cmp-nvim-lsp", -- Add this dependency for LSP completion
        },
        config = function()
            -- Define on_attach function for LSP keymaps
            local on_attach = function(_, bufnr)
                -- Buffer-local keymaps for LSP functionality
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame", buffer = bufnr })
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction", buffer = bufnr })
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition", buffer = bufnr })
                vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "[G]oto [R]eferences", buffer = bufnr })
                vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "[G]oto [I]mplementation", buffer = bufnr })
                vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type [D]efinition", buffer = bufnr })
                vim.keymap.set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, { desc = "[D]ocument [S]ymbols", buffer = bufnr })
                vim.keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "[W]orkspace [S]ymbols", buffer = bufnr })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation", buffer = bufnr })
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Documentation", buffer = bufnr })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration", buffer = bufnr })
                vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "[W]orkspace [A]dd Folder", buffer = bufnr })
                vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "[W]orkspace [R]emove Folder", buffer = bufnr })
                vim.keymap.set("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, { desc = "[W]orkspace [L]ist Folders", buffer = bufnr })

                -- Buffer-local :Format command
                vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
                    vim.lsp.buf.format()
                end, { desc = "Format current buffer with LSP" })
            end

            -- Setup neodev for better Lua development
            require("neodev").setup()
            
            -- Setup LSP capabilities and servers
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local servers = {
                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            }

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = servers[server_name],
                        })
                    end,
                },
            })
            require("fidget").setup()
        end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                },
            })
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "python" },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
        config = function()
            require("telescope").setup()
            -- Add keybindings for Telescope
            vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[F]ind [F]iles" })
            vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "[F]ind by [G]rep" })
            vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "[F]ind [B]uffers" })
            vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "[F]ind [H]elp" })
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end,
    },

    -- Git integration
    { "tpope/vim-fugitive" },
    { "tpope/vim-rhubarb" },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    -- Navigation keymaps
                    vim.keymap.set("n", "]c", function()
                        if vim.wo.diff then return "]c" end
                        vim.schedule(function() gs.next_hunk() end)
                        return "<Ignore>"
                    end, { expr = true, buffer = bufnr })
                    
                    vim.keymap.set("n", "[c", function()
                        if vim.wo.diff then return "[c" end
                        vim.schedule(function() gs.prev_hunk() end)
                        return "<Ignore>"
                    end, { expr = true, buffer = bufnr })
                    
                    -- Actions keymaps
                    vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "[H]unk [S]tage", buffer = bufnr })
                    vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "[H]unk [R]eset", buffer = bufnr })
                    vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "[H]unk [B]lame", buffer = bufnr })
                    vim.keymap.set("n", "<leader>hd", gs.diffthis, { desc = "[H]unk [D]iff", buffer = bufnr })
                end,
            })
        end,
    },

    -- Colorscheme
    { 
        "neanias/everforest-nvim",
        config = function()
            require("everforest").setup({
                background = "medium",
                transparent = false,
            })
            vim.cmd("colorscheme everforest")
        end,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = false,
                    theme = "everforest",
                    component_separators = "|",
                    section_separators = "",
                },
            })
        end,
    },

    -- Indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "┊" },
                scope = { enabled = false },
            })
        end,
    },

    -- Commenting
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    -- Detect tabstop and shiftwidth
    { "tpope/vim-sleuth" },

    -- Miscellaneous
    { 
        "ojroques/nvim-osc52",
        config = function()
            require('osc52').setup()
        end,
    },
    
    { 
        "mhartington/formatter.nvim",
        config = function()
            require("formatter").setup()
        end,
    },

    -- AI autocompletion
    {
        "yetone/avante.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("avante").setup({
                provider = "grok",
                vendors = {
                    ["grok"] = {
                        endpoint = "https://api.xai.com/v1/chat/completions",
                        model = "grok-2",
                        api_key_name = "XAI_API_KEY",
                        parse_curl_args = function(opts, code_opts)
                            return {
                                url = opts.endpoint,
                                headers = {
                                    ["Authorization"] = "Bearer " .. os.getenv(opts.api_key_name),
                                    ["Content-Type"] = "application/json",
                                },
                                body = vim.json.encode({
                                    model = opts.model,
                                    messages = {
                                        { role = "user", content = code_opts.question .. "\n" .. code_opts.code_content },
                                    },
                                    stream = true,
                                }),
                            }
                        end,
                        parse_response = function(data_stream, event_state, opts)
                            if event_state == "done" then
                                opts.on_complete()
                                return
                            end
                            if not data_stream or data_stream == "" then return end
                            local json = vim.json.decode(data_stream)
                            local content = json.choices and json.choices[1].delta.content
                            if content then
                                opts.on_chunk(content)
                            end
                        end,
                    },
                },
            })
        end,
    },
})

-- Add some extra useful keymaps
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>n", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>p", "<cmd>bprev<cr>", { desc = "Previous buffer" })

-- Add some basic Neovim settings
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers
vim.opt.cursorline = true       -- Highlight current line
vim.opt.ignorecase = true       -- Case insensitive searching
vim.opt.smartcase = true        -- Override ignorecase when search includes uppercase
