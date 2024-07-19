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

            {
                "stevearc/conform.nvim",
                lazy = true,
                cmd = "ConformInfo",
                keys = {
                    {
                        "<leader>lf",
                        function()
                            require("conform").format()
                        end,
                        desc = "File Formatting",
                        mode = { "n" },
                    },
                },
                opts = {
                    format = {
                        timeout_ms = 3000,
                        async = false, -- not recommended to change
                        quiet = false, -- not recommended to change
                        lsp_format = "fallback", -- not recommended to change
                    },
                    ---@type table<string, conform.FormatterUnit[]>
                    formatters_by_ft = {
                        lua = { "stylua" },
                        sh = { "shfmt" },
                        javascript = { "prettier" },
                        python = { "black" },
                        cpp = { "clang-format" },
                        markdown = { "prettier" },
                        html = { "prettier" },
                        css = { "prettier" },
                        json = { "prettier" },
                        jsonc = { "prettier" },
                        java = { "google-java-format" },
                        yaml = { "prettier" },
                    },
                    -- The options you set here will be merged with the builtin formatters.
                    -- You can also define any custom formatters here.
                    ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
                    formatters = {
                        injected = { options = { ignore_errors = true } },
                        -- # Example of using dprint only when a dprint.json file is present
                        -- dprint = {
                        --   condition = function(ctx)
                        --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
                        --   end,
                        -- },
                        --
                        -- # Example of using shfmt with extra args
                        -- shfmt = {
                        --   prepend_args = { "-i", "2", "-ci" },
                        -- },
                    },
                },
            },
            { -- lint
                "mfussenegger/nvim-lint",
                event = { "BufReadPost", "BufWritePost", "BufNewFile" },
                opts = {
                    -- Event to trigger linters
                    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
                    linters_by_ft = {
                        fish = { "fish" },
                        -- Use the "*" filetype to run linters on all filetypes.
                        -- ['*'] = { 'global linter' },
                        -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
                        -- ['_'] = { 'fallback linter' },
                        ["*"] = { "codespell" },
                        cpp = { "cpplint" },
                        markdown = { "markdownlint" },
                        python = { "pylint" },
                    },
                    -- LazyVim extension to easily override linter options
                    -- or add custom linters.
                    ---@type table<string,table>
                    linters = {
                        -- -- Example of using selene only when a selene.toml file is present
                        -- selene = {
                        --   -- `condition` is another LazyVim extension that allows you to
                        --   -- dynamically enable/disable linters based on the context.
                        --   condition = function(ctx)
                        --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
                        --   end,
                        -- },
                    },
                },
                config = function(_, opts)
                    local M = {}

                    local lint = require("lint")
                    for name, linter in pairs(opts.linters) do
                        if type(linter) == "table" and type(lint.linters[name]) == "table" then
                            lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
                            if type(linter.prepend_args) == "table" then
                                lint.linters[name].args = lint.linters[name].args or {}
                                vim.list_extend(lint.linters[name].args, linter.prepend_args)
                            end
                        else
                            lint.linters[name] = linter
                        end
                    end
                    lint.linters_by_ft = opts.linters_by_ft

                    function M.debounce(ms, fn)
                        local timer = vim.uv.new_timer()
                        return function(...)
                            local argv = { ... }
                            timer:start(ms, 0, function()
                                timer:stop()
                                vim.schedule_wrap(fn)(unpack(argv))
                            end)
                        end
                    end

                    function M.lint()
                        -- Use nvim-lint's logic first:
                        -- * checks if linters exist for the full filetype first
                        -- * otherwise will split filetype by "." and add all those linters
                        -- * this differs from conform.nvim which only uses the first filetype that has a formatter
                        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

                        -- Create a copy of the names table to avoid modifying the original.
                        names = vim.list_extend({}, names)

                        -- Add fallback linters.
                        if #names == 0 then
                            vim.list_extend(names, lint.linters_by_ft["_"] or {})
                        end

                        -- Add global linters.
                        vim.list_extend(names, lint.linters_by_ft["*"] or {})

                        -- Filter out linters that don't exist or don't match the condition.
                        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
                        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
                        names = vim.tbl_filter(function(name)
                            local linter = lint.linters[name]
                            if not linter then
                                LazyVim.warn("Linter not found: " .. name, { title = "nvim-lint" })
                            end
                            return linter
                                and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
                        end, names)

                        -- Run linters.
                        if #names > 0 then
                            lint.try_lint(names)
                        end
                    end

                    vim.api.nvim_create_autocmd(opts.events, {
                        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
                        callback = M.debounce(100, M.lint),
                    })
                end,
            },
        },
    },
}
