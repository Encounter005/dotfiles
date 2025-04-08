return {
    --CMP
    {
        "hrsh7th/nvim-cmp", -- The completion plugin
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path", -- path completions
            "hrsh7th/cmp-cmdline", -- cmdline completions
            "saadparwaiz1/cmp_luasnip", -- snippet completions
            -- "lukas-reineke/cmp-under-comparator", -- better sorting
            "hrsh7th/cmp-calc",
            "micangl/cmp-vimtex",
            -- "hrsh7th/cmp-nvim-lsp-signature-help",
            {
                "kawre/neotab.nvim",
                event = "InsertEnter",
                opts = {},
            },
            {
                "Exafunction/codeium.nvim",
                cmd = "Codeium",
                build = ":Codeium Auth",
                opts = {},
            },
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "f3fora/cmp-spell",
            -- snippets
            {
                "L3MON4D3/LuaSnip",
                dependencies = {
                    "rafamadriz/friendly-snippets",
                },
            },
        },
        config = function()
            local cmp, luasnip = require("cmp"), require("luasnip")

            local function border(hl_name)
                return {
                    { "┌", hl_name },
                    { "─", hl_name },
                    { "┐", hl_name },
                    { "│", hl_name },
                    { "┘", hl_name },
                    { "─", hl_name },
                    { "└", hl_name },
                    { "│", hl_name },
                }
            end

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            --Custom snippets
            local snippet_path = vim.fn.stdpath("config") .. "/snippets/"
            if not vim.tbl_contains(vim.opt.rtp:get(), snippet_path) then
                vim.opt.rtp:append(snippet_path)
            end
            require("luasnip.loaders.from_vscode").lazy_load()
            -- CMP settings
            local cmp_config = {
                confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                },
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
                view = {
                    entries = { name = "custom" },
                },
                formatting = {
                    format = function(_, item)
                        local icons = require("config.icons").kinds
                        if icons[item.kind] then
                            item.kind = icons[item.kind] .. item.kind
                        end
                        return item
                    end,
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = {
                        border = border("FloatBorder"),
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        col_offset = -3,
                        side_padding = 0,
                    },
                    documentation = {
                        border = border("FloatBorder"),
                    },
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "snippets" },
                    -- { name = "nvim_lsp_signature_help" },
                    { name = "codeium" },
                    { name = "nvim_lua" },
                    {
                        name = "spell",
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return true
                            end,
                            preselect_correct_word = true,
                        },
                    },
                    { name = "calc" },
                    { name = "treesitter" },
                    { name = "crates" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "vimtex" },
                },
                -- sorting = {
                --     comparators = {
                --         cmp.config.compare.offest,
                --         cmp.config.compare.exact,
                --         cmp.config.compare.score,
                --         require("cmp-under-comparator").under,
                --         cmp.config.compare.kind,
                --         cmp.config.compare.sort_text,
                --         cmp.config.compare.length,
                --         cmp.config.compare.order,
                --     },
                -- },
                mapping = {
                    ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if luasnip.expandable() then
                                luasnip.expand()
                            else
                                cmp.confirm({
                                    select = true,
                                })
                            end
                        else
                            fallback()
                        end
                    end),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
            }
            cmp.setup(cmp_config)
            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "cmdline" },
                }, {
                    { name = "path" },
                }),
            })
        end,
    },
}
