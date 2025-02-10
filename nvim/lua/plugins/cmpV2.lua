return {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
        "rafamadriz/friendly-snippets",
        -- nvim-cmp compat
        {
            "saghen/blink.compat",
            -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
            version = "*",
            -- make sure to set opts so that lazy.nvim calls blink.compat's setup
            opts = {},
        },
        "hrsh7th/cmp-calc",
        "micangl/cmp-vimtex",

        "rafamadriz/friendly-snippets",
        "Kaiser-Yang/blink-cmp-dictionary",
        "niuiic/blink-cmp-rg.nvim",
        { "echasnovski/mini.nvim", version = "*" },

        {
            "zbirenbaum/copilot.lua",
            config = function()
                require("copilot").setup({
                    suggestion = { enabled = false },
                    panel = { enabled = false },
                })
            end,
        },
        "giuxtaposition/blink-cmp-copilot",
        opts = {
            max_completions = 2, -- Global default for max completions
            max_attempts = 3, -- Global default for max attempts
            -- `kind` is not set, so the default value is "Copilot"
        },
    },
    event = "InsertEnter",

    -- use a release tag to download pre-built binaries
    version = "*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- 'default' for mappings similar to built-in completion
        -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
        -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
        -- See the full "keymap" documentation for information on defining your own keymap.
        keymap = { preset = "enter" },

        appearance = {
            kind_icons = {
                Copilot = ' ',
            },
            -- Sets the fallback highlight groups to nvim-cmp's highlight groups
            -- Useful for when your theme doesn't support blink.cmp
            -- Will be removed in a future release
            use_nvim_cmp_as_default = false,
            -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
        },

        completion = {
            accept = { auto_brackets = { enabled = true } },
            menu = {
                border = "single",
                draw = {
                    columns = {
                        { "kind_icon", "kind", gap = 1 },
                        { "label", "label_description", gap = 1 },
                    },
                    treesitter = { "lsp" },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
            ghost_text = {
                enabled = true,
            },
        },

        signature = {
            enabled = false,
            window = { border = "single" },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { "lsp", "path", "snippets", "buffer", "dictionary", "spell", "calc", "ripgrep", "copilot" },
            cmdline = function()
                local type = vim.fn.getcmdtype()
                if type == "/" or type == "?" then
                    return { "buffer" }
                end
                if type == ":" then
                    return { "cmdline" }
                end
                return {}
            end,
            providers = {
                lsp = {
                    name = "lsp",
                    enabled = true,
                    module = "blink.cmp.sources.lsp",
                    -- kind = "LSP",
                    min_keyword_length = 2,
                    -- When linking markdown notes, I would get snippets and text in the
                    -- suggestions, I want those to show only if there are no LSP
                    -- suggestions
                    --
                    -- Enabled fallbacks as this seems to be working now
                    -- Disabling fallbacks as my snippets wouldn't show up when editing
                    -- lua files
                    -- fallbacks = { "snippets", "buffer" },
                    score_offset = 85, -- the higher the number, the higher the priority
                },
                path = {
                    name = "Path",
                    module = "blink.cmp.sources.path",
                    score_offset = 25,
                    -- When typing a path, I would get snippets and text in the
                    -- suggestions, I want those to show only if there are no path
                    -- suggestions
                    fallbacks = { "snippets", "buffer" },
                    min_keyword_length = 2,
                    opts = {
                        trailing_slash = false,
                        label_trailing_slash = true,
                        get_cwd = function(context)
                            return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
                        end,
                        show_hidden_files_by_default = true,
                    },
                },
                dictionary = {
                    module = "blink-cmp-dictionary",
                    name = "Dict",
                    score_offset = 20, -- the higher the number, the higher the priority
                    -- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
                    enabled = true,
                    max_items = 8,
                    min_keyword_length = 3,
                    opts = {},
                },

                buffer = {
                    name = "Buffer",
                    enabled = true,
                    max_items = 3,
                    module = "blink.cmp.sources.buffer",
                    min_keyword_length = 4,
                    score_offset = 15, -- the higher the number, the higher the priority
                },
                snippets = {
                    name = "snippets",
                    enabled = true,
                    max_items = 15,
                    min_keyword_length = 2,
                    module = "blink.cmp.sources.snippets",
                    score_offset = 90, -- the higher the number, the higher the priority
                },

                spell = {
                    name = "spell",
                    module = "blink.compat.source",
                    score_offset = 8,
                    opts = {
                        keep_all_entries = false,
                        enable_in_context = function()
                            return true
                        end,
                        preselect_correct_word = true,
                    },

                },

                calc = {
                    name = "calc",
                    module = "blink.compat.source",
                    score_offset = 7,
                    opts = {},

                },

                ripgrep = {
                    module = "blink-cmp-rg",
                    name = "Ripgrep",
                    score_offset = 6,
                    -- options below are optional, these are the default values
                    ---@type blink-cmp-rg.Options
                    opts = {
                        -- `min_keyword_length` only determines whether to show completion items in the menu,
                        -- not whether to trigger a search. And we only has one chance to search.
                        prefix_min_len = 1,
                        get_command = function(context, prefix)
                            return {
                                "rg",
                                "--no-config",
                                "--json",
                                "--word-regexp",
                                "--ignore-case",
                                "--",
                                prefix .. "[\\w_-]+",
                                vim.fs.root(0, ".git") or vim.fn.getcwd(),
                            }
                        end,
                        get_prefix = function(context)
                            return context.line:sub(1, context.cursor[2]):match("[%w_-]+$") or ""
                        end,
                    },
                },

                copilot = {
                    name = "copilot",
                    module = "blink-cmp-copilot",
                    score_offset = -100,
                    async = true,

                    transform_items = function(_, items)
                        local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                        local kind_idx = #CompletionItemKind + 1
                        CompletionItemKind[kind_idx] = "Copilot"
                        for _, item in ipairs(items) do
                            item.kind = kind_idx
                        end
                        return items
                    end,
                },
            },
        },
    },
    opts_extend = { "sources.default" },
}
