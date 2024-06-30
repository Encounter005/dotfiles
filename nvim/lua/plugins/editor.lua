return {

    {
        "vigoux/LanguageTool.nvim", -- check grammar
        ft = {"markdown", "text", "latex", "latexmk"},
    },
    {
        "amrbashir/nvim-docs-view",
        lazy = true,
        cmd = "DocsViewToggle",
        opts = {
            position = "right",
            width = 40,
        },
    },
    {

        "RRethy/vim-illuminate",
        lazy = true,
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = {
                    "lsp",
                    "treesitter",
                    "regex",
                },
            },
        },
        config = function(_, opts)
            require("illuminate").configure(opts)

            local function map(key, dir, buffer)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. dir .. "_reference"](false)
                end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
            end

            map("]]", "next")
            map("[[", "prev")

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map("]]", "next", buffer)
                    map("[[", "prev", buffer)
                end,
            })
        end,
    },

    { -- latex
        "lervag/vimtex",
        init = function()
            vim.g.vimtex_view_method = "zahtura"
            vim.g.vimtex_skim_sync = 1
            vim.g.vimtex_compiler_latexmk = {
                continuous = 0,
            }
        end,
        lazy = false,
    },
    -- Markdown
    {
        "MeanderingProgrammer/markdown.nvim",
        ft = { "markdown" },
        lazy = true,
        name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("render-markdown").setup({})
        end,
    },

    {
        "jghauser/follow-md-links.nvim",
        lazy = true,
        ft = "markdown",
        vim.keymap.set("n", "<bs>", ":edit #<cr>", { silent = true }),
    },

    { -- powerful tools in markdown files
        "tadmccorkle/markdown.nvim",
        ft = "markdown",
        opts = {},
    },
    { -- gernerate contents
        "mzlogin/vim-markdown-toc",
        ft = {
            "markdown",
        },
        lazy = true,
        event = "BufReadPre",
    },

    { -- Markdown Preview
        "toppair/peek.nvim",
        ft = { "markdown" },
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup()
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },

    {
        "norcalli/nvim-colorizer.lua",
        lazy = true,
        event = "User Fileopened",
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
        -- use opts = {} for passing setup options
        -- this is equalent to setup({}) function
        opts = {
            disable_filetype = { "TelescopePrompt", "spectre_panel" },
            disable_in_macro = true, -- disable when recording or executing a macro
            disable_in_visualblock = false, -- disable when insert after visual block mode
            disable_in_replace_mode = true,
            ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
            enable_moveright = true,
            enable_afterquote = true, -- add bracket pairs after quote
            enable_check_bracket_line = true, --- check bracket in same line
            enable_bracket_in_quote = true, --
            enable_abbr = false, -- trigger abbreviation
            break_undo = true, -- switch for basic rule break undo sequence
            check_ts = false,
            map_cr = true,
            map_bs = true, -- map the <BS> key
            map_c_h = false, -- Map the <C-h> key to delete a pair
            map_c_w = false, -- map <c-w> to delete a pair if possible
        },
    },

    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        dependencies = {},
        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treesitter** module to be loaded in time.
            -- Luckily, the only things that those plugins need are the custom queries, which we make available
            -- during startup.
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                config = function()
                    -- When in diff mode, we want to use the default
                    -- vim text objects c & C instead of the treesitter ones.
                    local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
                    local configs = require("nvim-treesitter.configs")
                    for name, fn in pairs(move) do
                        if name:find("goto") == 1 then
                            move[name] = function(q, ...)
                                if vim.wo.diff then
                                    local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                                    for key, query in pairs(config or {}) do
                                        if q == query and key:find("[%]%[][cC]") then
                                            vim.cmd("normal! " .. key)
                                            return
                                        end
                                    end
                                end
                                return fn(q, ...)
                            end
                        end
                    end
                end,
            },
            {
                "nvim-treesitter/nvim-treesitter-context",
                event = { "BufReadPost", "BufWritePost", "BufNewFile" },
                enabled = true,
                opts = { mode = "cursor", max_lines = 3 },
            },

            {
                "windwp/nvim-ts-autotag",
                event = "VeryLazy",
                opts = {},
            },
        },
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        ---@type TSConfig
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "diff",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "jsonc",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
            textobjects = {
                move = {
                    enable = true,
                    goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                    goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
                    goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                    goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
                },
            },
        },
        ---@param opts TSConfig
        config = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                ---@type table<string, boolean>
                local added = {}
                opts.ensure_installed = vim.tbl_filter(function(lang)
                    if added[lang] then
                        return false
                    end
                    added[lang] = true
                    return true
                end, opts.ensure_installed)
            end
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- Web Development
    {
        "ray-x/web-tools.nvim",
        ft = { "html", "css" },
        config = function()
            require("web-tools").setup({})
        end,
    },

    {
        "luckasRanarison/tailwind-tools.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "html", "css" },
        opts = {}, -- your configuration
    },
}
