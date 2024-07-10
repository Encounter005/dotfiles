return {
    -- LSP
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        dependencies = {
            {
                "folke/neodev.nvim",
                ft = "lua",
                lazy = true,
            },
            {
                "simrat39/rust-tools.nvim",
                ft = "rust",
                lazy = true,
            },

            --Rust
            {
                "rust-lang/rust.vim",
                lazy = true,
                ft = "rust",
            },

            { -- Java Support
                "nvim-java/lua-async-await",
                "nvim-java/nvim-java-refactor",
                "nvim-java/nvim-java-core",
                "nvim-java/nvim-java-test",
                "nvim-java/nvim-java-dap",
                "mfussenegger/nvim-jdtls",
                ft = { "java" },
                config = function()
                    require("java").setup()
                    local opts = {
                        cmd = { "~/.local/share/nvim/mason/bin/jdtls" },
                        root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
                    }
                    require("jdtls").start_or_attach(opts)
                end,
            },
            {
                "williamboman/mason.nvim",
                cmd = "Mason",
                build = ":MasonUpdate",
                config = function()
                    local servers = {
                        "lua_ls",
                        "cssls",
                        "tsserver",
                        "ltex",
                        "stimulus_ls",
                        "pylsp",
                        "bashls",
                        "jsonls",
                        "clangd",
                        "neocmake",
                        "marksman",
                        "yamlls",
                        "jdtls",
                        "bashls",
                        "vimls",
                        "volar",
                        "rust_analyzer",
                        "gopls",
                    }

                    local settings = {
                        ui = {
                            border = "rounded",
                            icons = {
                                package_installed = "◍",
                                package_pending = "◍",
                                package_uninstalled = "◍",
                            },
                        },
                        log_level = vim.log.levels.INFO,
                        max_concurrent_installers = 4,
                        registries = {
                            "github:nvim-java/mason-registry",
                            "github:mason-org/mason-registry",
                        },
                    }

                    require("mason").setup(settings)
                    require("mason-lspconfig").setup({
                        ensure_installed = servers,
                        automatic_installation = true,
                    })

                    local lspconfig = require("lspconfig")
                    local handlers = require("utils.handlers")
                    handlers.setup()
                    for _, server in ipairs(servers) do
                        opts = {
                            on_attach = handlers.on_attach,
                            capabilities = handlers.capabilities,
                        }

                        server = vim.split(server, "@")[1]

                        local require_ok, conf_opts = pcall(require, "utils.settings." .. server)
                        if require_ok then
                            opts = vim.tbl_deep_extend("force", conf_opts, opts)
                        end

                        lspconfig[server].setup({ opts })
                    end
                end,
            },
            {
                "williamboman/mason-lspconfig.nvim", -- simple to use language server installer
            },
            {
                "VidocqH/lsp-lens.nvim",
                event = "BufRead",
                config = function()
                    require("lsp-lens").setup()
                end,
            },

            {
                "nvimdev/lspsaga.nvim",
                config = function()
                    local icons = require("config.icons")
                    require("lspsaga").setup({
                        ui = {
                            theme = "round",
                            title = true,
                            border = "rounded",
                            code_action = icons.diagnostics.Hint,
                        },
                    })
                end,
            },

            { -- formatter
                "nvimdev/guard.nvim",
                dependencies = { "nvimdev/guard-collection" },
                event = "User Fileopened",
                config = function()
                    local guard = require("guard")
                    local ft = require("guard.filetype")
                    ft("c", "cpp"):fmt("clang-format"):lint("clang-tidy")
                    ft("lua"):fmt("stylua"):lint("luacheck")
                    ft("go"):fmt("gofumpt")
                    ft("python"):fmt("autopep8")
                    -- :lint("pylint")
                    ft("markdown", "css", "jsonc", "js", "html"):fmt("prettier"):lint("codespell")
                    ft("java"):fmt("lsp")

                    guard.setup({
                        fmt_on_save = false,
                        lsp_as_default_formatter = true,
                    })
                end,
            },
        },
    },
}
