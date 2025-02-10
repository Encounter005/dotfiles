return {
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = {
            -- nvim-cmp compat
            {
                "saghen/blink.compat",
                -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
                version = "*",
                -- make sure to set opts so that lazy.nvim calls blink.compat's setup
                opts = {},
            },
            {
                "Exafunction/codeium.nvim",
                cmd = "Codeium",
                build = ":Codeium Auth",
                opts = {},
            },
            "hrsh7th/cmp-calc",
            "micangl/cmp-vimtex",

            "rafamadriz/friendly-snippets",
            "Kaiser-Yang/blink-cmp-dictionary",
            "niuiic/blink-cmp-rg.nvim",
            { "echasnovski/mini.nvim", version = "*" },
            event = "InsertEnter",
        },

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
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = false,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            completion = {
                -- 'prefix' will fuzzy match on the text before the cursor
                -- 'full' will fuzzy match on the text before *and* after the cursor
                -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
                -- Disable auto brackets
                -- NOTE: some LSPs may add auto brackets themselves anyway
                accept = { auto_brackets = { enabled = true } },
                -- keyword = { range = "full" },
                -- Don't select by default, auto insert on selection
                menu = {
                    border = "single",
                    draw = {
                        columns = {
                            { "kind_icon", "kind" },
                            { "label", "label_description", gap = 1 },
                        },
                        treesitter = { "lsp" },
                        components = {
                            kind_icon = {
                                ellipsis = false,
                                text = function(ctx)
                                    local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                                    return kind_icon
                                end,
                                highlight = function(ctx)
                                    local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                    return hl
                                end,
                            },
                        },
                    },
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
                default = { "lsp", "path", "snippets", "buffer", "ripgrep", "dictionary", "codeium", "spell", "calc" },
                cmdline = {},
                providers = {
                    spell = {
                        name = "spell",
                        module = "blink.compat.source",
                        score_offset = -3,
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
                        score_offset = -3,
                        opts = {},
                    },

                    codeium = {
                        name = "codeium",
                        module = "blink.compat.source",
                        score_offset = -3,
                        opts = {
                            virtual_text = { enabled = true },
                        },
                    },
                    dictionary = {
                        module = "blink-cmp-dictionary",
                        name = "Dict",
                        -- Make sure this is at least 2.
                        -- 3 is recommended
                        min_keyword_length = 3,
                        opts = {
                            -- options for blink-cmp-dictionary
                        },
                    },
                    ripgrep = {
                        module = "blink-cmp-rg",
                        name = "Ripgrep",
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
                },
                min_keyword_length = function(ctx)
                    -- only applies when typing a command, doesn't apply to arguments
                    if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                        return 3
                    end
                    return 1
                end,
            },
        },
        opts_extend = {
            "sources.completion.enabled_providers",
            "sources.default",
        },
    },
}
