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
                "Wansmer/symbol-usage.nvim",
                event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
                config = function()
                    local function h(name)
                        return vim.api.nvim_get_hl(0, { name = name })
                    end

                    -- hl-groups can have any name
                    vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
                    vim.api.nvim_set_hl(
                        0,
                        "SymbolUsageContent",
                        { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true }
                    )
                    vim.api.nvim_set_hl(
                        0,
                        "SymbolUsageRef",
                        { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true }
                    )
                    vim.api.nvim_set_hl(
                        0,
                        "SymbolUsageDef",
                        { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true }
                    )
                    vim.api.nvim_set_hl(
                        0,
                        "SymbolUsageImpl",
                        { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true }
                    )

                    local function text_format(symbol)
                        local res = {}

                        local round_start = { "", "SymbolUsageRounding" }
                        local round_end = { "", "SymbolUsageRounding" }

                        -- Indicator that shows if there are any other symbols in the same line
                        local stacked_functions_content = symbol.stacked_count > 0
                                and ("+%s"):format(symbol.stacked_count)
                            or ""

                        if symbol.references then
                            local usage = symbol.references <= 1 and "usage" or "usages"
                            local num = symbol.references == 0 and "no" or symbol.references
                            table.insert(res, round_start)
                            table.insert(res, { "󰌹 ", "SymbolUsageRef" })
                            table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
                            table.insert(res, round_end)
                        end

                        if symbol.definition then
                            if #res > 0 then
                                table.insert(res, { " ", "NonText" })
                            end
                            table.insert(res, round_start)
                            table.insert(res, { "󰳽 ", "SymbolUsageDef" })
                            table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
                            table.insert(res, round_end)
                        end

                        if symbol.implementation then
                            if #res > 0 then
                                table.insert(res, { " ", "NonText" })
                            end
                            table.insert(res, round_start)
                            table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
                            table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
                            table.insert(res, round_end)
                        end

                        if stacked_functions_content ~= "" then
                            if #res > 0 then
                                table.insert(res, { " ", "NonText" })
                            end
                            table.insert(res, round_start)
                            table.insert(res, { " ", "SymbolUsageImpl" })
                            table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
                            table.insert(res, round_end)
                        end

                        return res
                    end
                    require("symbol-usage").setup({
                        text_format = text_format,
                    })
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
