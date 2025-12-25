return {
    {
        "saghen/blink.cmp",
        event = "InsertEnter",

        -- optional: provides snippets for the snippet source
        dependencies = {
            "rafamadriz/friendly-snippets",
            "ribru17/blink-cmp-spell",
            {
                "saghen/blink.compat",
                opts = {
                    enabled_events = true,
                },
            },
            "echasnovski/mini.nvim",
            "hrsh7th/cmp-calc",
            {
                "Exafunction/codeium.nvim",
                opts = {},
            },
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
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-e: Hide menu
            -- C-k: Toggle signature help
            --
            -- See the full "keymap" documentation for information on defining your own keymap.
            keymap = { preset = "enter" },

            appearance = {
                kind_icons = {
                    Copilot = " ",
                    Codeium = "ﲃ",
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
                accept = {
                    -- experimental auto-brackets support
                    auto_brackets = {
                        enabled = true,
                    },
                },
                menu = {
                    draw = {
                        columns = {
                            { "kind_icon", gap = 1 },
                            { "label", "label_description", gap = 1 },
                            { "kind" },
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
            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "calc", "spell", "codeium" },
                providers = {
                    codeium = {
                        name = "codeium",
                        module = "blink.compat.source",
                        async = true,
                        score_offset = 98,
                    },
                    calc = {
                        name = "calc",
                        module = "blink.compat.source",
                        score_offset = 7,
                        opts = {},
                    },
                    snippets = {
                        name = "Snippets",
                        enabled = true,
                        module = "blink.cmp.sources.snippets",
                        max_items = 15,
                        min_keyword_length = 2,
                        score_offset = 90, -- the higher the number, the higher the priority
                    },
                    spell = {
                        name = "Spell",
                        module = "blink-cmp-spell",
                        opts = {
                            -- EXAMPLE: Only enable source in `@spell` captures, and disable it
                            -- in `@nospell` captures.
                            enable_in_context = function()
                                local curpos = vim.api.nvim_win_get_cursor(0)
                                local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
                                local in_spell_capture = false
                                for _, cap in ipairs(captures) do
                                    if cap.capture == "spell" then
                                        in_spell_capture = true
                                    elseif cap.capture == "nospell" then
                                        return false
                                    end
                                end
                                return in_spell_capture
                            end,
                        },
                    },
                },
            },

            -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            -- It is recommended to put the "label" sorter as the primary sorter for the
            -- spell source.
            -- If you set use_cmp_spell_sorting to true, you may want to skip this step.
            fuzzy = {
                sorts = {
                    function(a, b)
                        local sort = require("blink.cmp.fuzzy.sort")
                        if a.source_id == "spell" and b.source_id == "spell" then
                            return sort.label(a, b)
                        end
                    end,
                    -- This is the normal default order, which we fall back to
                    "score",
                    "kind",
                    "label",
                },
            },
            cmdline = {
                enabled = true,
                keymap = { preset = "cmdline" },
                sources = function()
                    local type = vim.fn.getcmdtype()
                    -- Search forward and backward
                    if type == "/" or type == "?" then
                        return { "buffer" }
                    end
                    -- Commands
                    if type == ":" or type == "@" then
                        return { "cmdline" }
                    end
                    return {}
                end,
                completion = {
                    trigger = {
                        show_on_blocked_trigger_characters = {},
                        show_on_x_blocked_trigger_characters = {},
                    },
                    list = {
                        selection = {
                            -- When `true`, will automatically select the first item in the completion list
                            preselect = true,
                            -- When `true`, inserts the completion item automatically when selecting it
                            auto_insert = true,
                        },
                    },
                    -- Whether to automatically show the window when new completion items are available
                    menu = { auto_show = true },
                    -- Displays a preview of the selected item on the current line
                    ghost_text = { enabled = true },
                    
                },
            },
        },
        opts_extend = {
            "sources.completion.enabled_providers",
            "sources.compat",
            "sources.default",
        },
    },
}
