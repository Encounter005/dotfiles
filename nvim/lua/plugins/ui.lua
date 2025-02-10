return {
    "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
    { -- Useful lua functions used ny lots of plugins
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
    { --better quickfix window
        "kevinhwang91/nvim-bqf",
        event = { "VeryLazy" },
        ft = "qf",
    },
    {
        "MunifTanjim/nui.nvim",
        lazy = true,
    },
    {
        "yamatsum/nvim-nonicons",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        lazy = true,
    },
    { --better vim.ui
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

    --UI
    {
        "rcarriga/nvim-notify", -- notify
        config = function()
            local notify = require("notify")
            notify.setup({
                stages = "slide",
                on_open = nil,
                timeout = 300,
                max_width = function()
                    return math.floor(vim.o.columns * 0.75)
                end,
                max_height = function()
                    return math.floor(vim.o.lines * 0.75)
                end,
                render = "compact",
            })
        end,
    },

    --color scheme

    {
        "vague2k/vague.nvim",
        config = function()
            require("vague").setup({
                -- optional configuration here
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = true,
        event = { "BufEnter" },
    },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        event = { "BufEnter" },
        opts = {
            integration = { blink_cmp = true },
        },
    },

    {
        "rebelot/kanagawa.nvim",
        lazy = true,
        event = { "BufEnter" },
    },

    {
        "nyoom-engineering/oxocarbon.nvim",
        lazy = true,
        event = { "BufEnter" },
    },

    {
        "olivercederborg/poimandres.nvim",
        lazy = true,
        event = { "BufEnter" },
    },

    {
        "uloco/bluloco.nvim",
        dependencies = { "rktjmp/lush.nvim" },
        lazy = true,
        event = { "BufEnter" },
    },

    {
        "ronisbr/nano-theme.nvim",
        lazy = true,
        event = { "BufEnter" },
    },

    {
        "shaunsingh/nord.nvim",
        lazy = true,
        event = { "BufEnter" },
    },

    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        opts = function()
            local opts = {
                theme = "doom",
                hide = {
                    -- this is taken care of by lualine
                    -- enabling this messes up the actual laststatus setting after loading a file
                    statusline = true,
                },
                config = {
                    header = {
                        "",
                        " ⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷ ",
                        " ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇ ",
                        " ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽ ",
                        " ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕ ",
                        " ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕ ",
                        " ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕ ",
                        " ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄ ",
                        " ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕ ",
                        " ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿ ",
                        " ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ ",
                        " ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟ ",
                        " ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠ ",
                        " ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙ ",
                        " ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣ ",
                        "",
                    },
                    -- stylua: ignore
                    center = {
                        { action = "Telescope find_files",              desc = " Find file",          icon = " ", key = "f" },
                        { action = "ene | startinsert",                 desc = " New file",           icon = " ", key = "n" },
                        { action = "Telescope oldfiles",                desc = " Recent files",       icon = " ", key = "r" },
                        { action = "Telescope live_grep",               desc = " Find text",          icon = " ", key = "t" },
                        { action = 'lua require("persistence").load()', desc = " Restore Session",    icon = " ", key = "S" },
                        { action = "Telescope colorscheme",             desc = " Change colorscheme", icon = " ", key = "s" },
                        { action = ":e ~/.config/nvim/init.lua",        desc = " Configure",          icon = " ", key = "c" },
                        { action = "Lazy",                              desc = " Lazy",               icon = "󰒲 ", key = "p" },
                        { action = "qa",                                desc = " Quit",               icon = " ", key = "q" },
                    },
                    footer = function()
                        local stats = require("lazy").stats()
                        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                        return {
                            "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
                        }
                    end,
                },
            }

            for _, button in ipairs(opts.config.center) do
                button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
                button.key_format = "  %s"
            end

            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "DashboardLoaded",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            return opts
        end,
    },

    --Better nvim-ui
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            cmdline = {
                view = "cmdline",
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
            },
        },
    },

    -- { -- statusline
    --     "glepnir/galaxyline.nvim",
    --     event = "VimEnter",
    --     config = function()
    --         local gl = require("galaxyline")
    --         local gls = gl.section
    --         local iconz = require("nvim-nonicons")
    --         local current_scheme = vim.g.colors_name
    --         local colors = {
    --             bg = "#0d0d0d",
    --             fg = "#b2b2b9",
    --             black = "#191919",
    --             yellow = "#E5C07B",
    --             cyan = "#70C0BA",
    --             dimblue = "#83A598",
    --             green = "#98C379",
    --             orange = "#FF8800",
    --             purple = "#C678DD",
    --             magenta = "#D27E99",
    --             blue = "#81A1C1",
    --             red = "#D54E53",
    --             divider = "#24242e",
    --         }
    --
    --         if current_scheme == "everforest" then
    --             colors.bg = "#282E2C"
    --             colors.black = "#222B28"
    --         elseif current_scheme == "gruvbox" then
    --             colors.bg = "#261C00"
    --             colors.black = "#3A2300"
    --             colors.divider = "#322e2e"
    --         elseif current_scheme == "dawnfox" then
    --             colors.bg = "#898180"
    --             colors.black = "#625c5c"
    --         elseif current_scheme:match("github_light[%l_]*") then
    --             local custom = {
    --                 fg = "#24292f",
    --                 bg = "#bbd6ee",
    --                 black = "#9fc5e8",
    --                 yellow = "#dbab09",
    --                 cyan = "#0598bc",
    --                 green = "#28a745",
    --                 orange = "#d18616",
    --                 magenta = "#5a32a3",
    --                 purple = "#5a32a3",
    --                 blue = "#0366d6",
    --                 red = "#d73a49",
    --             }
    --             -- merge custom color to default
    --             colors = vim.tbl_deep_extend("force", {}, colors, custom)
    --         end
    --
    --         local checkwidth = function()
    --             local squeeze_width = vim.fn.winwidth(0) / 2
    --             if squeeze_width > 50 then
    --                 return true
    --             end
    --             return false
    --         end
    --
    --         local function should_activate_lsp()
    --             local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    --             return checkwidth() and #clients ~= 0
    --         end
    --
    --         local buffer_not_empty = function()
    --             if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
    --                 return true
    --             end
    --             return false
    --         end
    --
    --         -- insert_left insert item at the left panel
    --         local function insert_left(element)
    --             table.insert(gls.left, element)
    --         end
    --
    --         -- insert_right insert given item into galaxyline.right
    --         local function insert_right(element)
    --             table.insert(gls.right, element)
    --         end
    --
    --         -----------------------------------------------------
    --         ----------------- start insert ----------------------
    --         -----------------------------------------------------
    --         -- { mode panel start
    --         insert_left({
    --             ViMode = {
    --                 provider = function()
    --                     return " "
    --                 end,
    --                 highlight = { colors.black, colors.black },
    --             },
    --         })
    --
    --         insert_left({
    --             ViModeIcon = {
    --                 provider = function()
    --                     -- auto change color according the vim mode
    --                     local alias = {
    --                         n = "  NORMAL",
    --                         i = " INSERT",
    --                         c = " COMMAND",
    --                         V = " VISUAL",
    --                         [""] = " VISUAL",
    --                         v = " VISUAL",
    --                         C = "",
    --                         ["r?"] = "?",
    --                         rm = "M",
    --                         R = " REPLACE",
    --                         Rv = " REPLACE",
    --                         s = " SELECT",
    --                         S = " SELECT",
    --                         ["r"] = "HIT-ENTER",
    --                         [""] = "",
    --                         t = " TERMINAL",
    --                         ["!"] = "",
    --                     }
    --
    --                     local mode = vim.fn.mode()
    --                     local vim_mode_color = {
    --                         n = colors.yellow,
    --                         i = colors.green,
    --                         v = colors.blue,
    --                         [""] = colors.blue,
    --                         V = colors.blue,
    --                         c = colors.magenta,
    --                         no = colors.red,
    --                         s = colors.orange,
    --                         S = colors.orange,
    --                         [""] = colors.orange,
    --                         ic = colors.yellow,
    --                         R = colors.purple,
    --                         Rv = colors.purple,
    --                         cv = colors.red,
    --                         ce = colors.red,
    --                         r = colors.cyan,
    --                         rm = colors.cyan,
    --                         ["r?"] = colors.cyan,
    --                         ["!"] = colors.red,
    --                         t = colors.red,
    --                     }
    --
    --                     vim.api.nvim_set_hl(0, "GalaxyViMode", { fg = vim_mode_color[mode], bg = colors.bg })
    --                     return alias[mode]
    --                 end,
    --                 highlight = "GalaxyViMode",
    --             },
    --         })
    --
    --         insert_left({
    --             EndingSepara = {
    --                 provider = function()
    --                     return " "
    --                 end,
    --                 highlight = function()
    --                     if should_activate_lsp() then
    --                         return { colors.bg, colors.black }
    --                     else
    --                         return { colors.bg, colors.divider }
    --                     end
    --                 end,
    --             },
    --         })
    --
    --         insert_left({
    --             FileIcon = {
    --                 provider = "FileIcon",
    --                 condition = function()
    --                     return buffer_not_empty() and should_activate_lsp()
    --                 end,
    --                 highlight = {
    --                     require("galaxyline.provider_fileinfo").get_file_icon_color,
    --                     colors.black,
    --                 },
    --             },
    --         })
    --
    --         insert_left({
    --             GetLspClient = {
    --                 provider = "GetLspClient",
    --                 condition = should_activate_lsp,
    --                 highlight = { colors.fg, colors.black },
    --             },
    --         })
    --
    --         insert_left({
    --             LspSpace = {
    --                 provider = function()
    --                     return " "
    --                 end,
    --                 condition = should_activate_lsp,
    --                 highlight = { colors.black, colors.black },
    --             },
    --         })
    --
    --         insert_left({
    --             DiagnosticError = {
    --                 provider = "DiagnosticError",
    --                 condition = should_activate_lsp,
    --                 icon = "  ",
    --                 highlight = { colors.red, colors.black },
    --             },
    --         })
    --
    --         insert_left({
    --             DiagnosticWarn = {
    --                 provider = "DiagnosticWarn",
    --                 condition = should_activate_lsp,
    --                 icon = "  ",
    --                 highlight = { colors.yellow, colors.black },
    --             },
    --         })
    --
    --         insert_left({
    --             DiagnosticInfo = {
    --                 provider = "DiagnosticInfo",
    --                 condition = should_activate_lsp,
    --                 highlight = { colors.green, colors.black },
    --                 icon = "  ",
    --             },
    --         })
    --
    --         insert_left({
    --             DiagnosticHint = {
    --                 provider = "DiagnosticHint",
    --                 condition = should_activate_lsp,
    --                 highlight = { colors.white, colors.black },
    --                 icon = "  ",
    --             },
    --         })
    --
    --         insert_left({
    --             LeftEnd = {
    --                 provider = function()
    --                     return ""
    --                 end,
    --                 condition = should_activate_lsp,
    --                 highlight = { colors.black, colors.divider },
    --             },
    --         })
    --
    --         insert_left({
    --             MiddleSpace = {
    --                 provider = function()
    --                     return " "
    --                 end,
    --                 highlight = { colors.black, colors.divider },
    --             },
    --         })
    --
    --         insert_right({
    --             RightStart = {
    --                 provider = function()
    --                     return " "
    --                 end,
    --                 highlight = { colors.black, colors.divider },
    --             },
    --         })
    --
    --         insert_right({
    --             GitIcon = {
    --                 provider = function()
    --                     return "  "
    --                 end,
    --                 condition = require("galaxyline.provider_vcs").check_git_workspace,
    --                 highlight = { colors.fg, colors.black },
    --             },
    --         })
    --
    --         insert_right({
    --             GitBranch = {
    --                 provider = "GitBranch",
    --                 condition = require("galaxyline.provider_vcs").check_git_workspace,
    --                 highlight = { colors.fg, colors.black },
    --             },
    --         })
    --
    --         insert_right({
    --             RightSpace = {
    --                 provider = function()
    --                     return " "
    --                 end,
    --                 highlight = { colors.black, colors.black },
    --             },
    --         })
    --
    --         insert_right({
    --             DiffAdd = {
    --                 provider = "DiffAdd",
    --                 condition = checkwidth,
    --                 icon = "  ",
    --                 highlight = { colors.green, colors.black },
    --             },
    --         })
    --
    --         insert_right({
    --             DiffModified = {
    --                 provider = "DiffModified",
    --                 condition = checkwidth,
    --                 icon = "  ",
    --                 highlight = { colors.yellow, colors.black },
    --             },
    --         })
    --
    --         insert_right({
    --             DiffRemove = {
    --                 provider = "DiffRemove",
    --                 condition = checkwidth,
    --                 icon = "  ",
    --                 highlight = { colors.red, colors.black },
    --             },
    --         })
    --
    --         insert_right({
    --             RightEndingSepara = {
    --                 provider = function()
    --                     return ""
    --                 end,
    --                 highlight = { colors.bg, colors.black },
    --             },
    --         })
    --
    --         insert_right({
    --             LineInfo = {
    --                 provider = "LineColumn",
    --                 separator = "  ",
    --                 separator_highlight = { colors.fg, colors.bg },
    --                 highlight = { colors.fg, colors.bg },
    --             },
    --         })
    --
    --         insert_right({
    --             RightSpacing = {
    --                 provider = function()
    --                     return "   "
    --                 end,
    --                 highlight = { colors.bg, colors.bg },
    --             },
    --         })
    --
    --         insert_right({
    --             PerCent = {
    --                 provider = "LinePercent",
    --                 condition = checkwidth,
    --                 highlight = { colors.fg, colors.bg },
    --             },
    --         })
    --
    --         insert_right({
    --             RightSpacing = {
    --                 provider = function()
    --                     return "   "
    --                 end,
    --                 highlight = { colors.bg, colors.bg },
    --             },
    --         })
    --
    --         insert_right({
    --             FileFormat = {
    --                 provider = "FileEncode",
    --                 condition = checkwidth,
    --                 highlight = { colors.fg, colors.bg },
    --             },
    --         })
    --
    --         insert_right({
    --             RightEnding = {
    --                 provider = function()
    --                     return " "
    --                 end,
    --                 highlight = { colors.bg, colors.bg },
    --             },
    --         })
    --
    --         -- ============================= short line ===============================
    --
    --         local BufferTypeMap = {
    --             ["DiffviewFiles"] = " Diff View",
    --             ["FTerm"] = "Terminal",
    --             ["Mundo"] = "Mundo History",
    --             ["MundoDiff"] = "Mundo Diff",
    --             ["NeogitCommitMessage"] = " Neogit Commit",
    --             ["NeogitPopup"] = " Neogit Popup",
    --             ["NeogitStatus"] = " Neogit Status",
    --             ["NvimTree"] = " Tree",
    --             ["Outline"] = " SymbolOutline",
    --             ["dap-repl"] = " Dap REPL",
    --             ["dapui_breakpoints"] = " Dap Breakpoints",
    --             ["dapui_scopes"] = "כֿ Dap Scope",
    --             ["dapui_stacks"] = " Dap Stacks",
    --             ["dapui_watches"] = "ﭓ Dap Watch",
    --             ["fern"] = " Fern FM",
    --             ["neo-tree"] = " Files",
    --             ["fugitive"] = " Fugitive",
    --             ["floggraph"] = " Git Log",
    --             ["fugitiveblame"] = " Fugitive Blame",
    --             ["git"] = " Git",
    --             ["help"] = " Help",
    --             ["minimap"] = "Minimap",
    --             ["neoterm"] = " NeoTerm",
    --             ["qf"] = " Quick Fix",
    --             ["tabman"] = "Tab Manager",
    --             ["tagbar"] = "Tagbar",
    --             ["toggleterm"] = " ToggleTerm",
    --             ["Trouble"] = "ﮒ Diagnostic",
    --         }
    --
    --         gl.short_line_list = vim.tbl_keys(BufferTypeMap)
    --
    --         require("galaxyline").section.short_line_left = {
    --             {
    --                 ShortLineLeftBufferType = {
    --                     highlight = { colors.black, colors.cyan },
    --                     provider = function()
    --                         -- return filename for normal file
    --                         local get_file_name = function()
    --                             return string.format("%s %s", "", vim.fn.pathshorten(vim.fn.expand("%")))
    --                         end
    --                         local name = BufferTypeMap[vim.bo.filetype] or get_file_name()
    --                         return string.format("  %s", name)
    --                     end,
    --                     separator = " ",
    --                     separator_highlight = { colors.cyan, colors.bg },
    --                 },
    --             },
    --             {
    --                 ShortLineLeftWindowNumber = {
    --                     highlight = { colors.cyan, colors.bg },
    --                     provider = function()
    --                         return " " .. vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
    --                     end,
    --                     separator = "",
    --                     separator_highlight = { colors.black, colors.bg },
    --                 },
    --             },
    --         }
    --     end,
    -- },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            local icons = require("config.icons")
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    -- section_separators = { right = "", left = "" },
                    disabled_filetypes = {
                        "help",
                        "dashboard",
                        "Trouble",
                        "trouble",
                        "notify",
                    },
                    always_divide_middle = true,
                },
                sections = {
                    lualine_a = {
                        "mode",
                    },
                    lualine_b = {
                        "branch",
                    },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                        {
                            "filetype",
                            icon_only = true,
                            separator = "",
                            padding = { left = 1, right = 0 },
                        },

                        {
                            "filename",
                            path = 1,
                            file_status = true,
                            padding = { left = 0, right = 0 },
                        },
                    },
                    lualine_x = {
                        {
                            function()
                                return require("noice").api.status.command.get()
                            end,
                            cond = function()
                                return package.loaded["noice"] and require("noice").api.status.command.has()
                            end,
                        },

                        {
                            function()
                                return require("noice").api.status.mode.get()
                            end,
                            cond = function()
                                return package.loaded["noice"] and require("noice").api.status.mode.has()
                            end,
                        },
                        {
                            -- Lsp server name .
                            function()
                                local msg = "No Active Lsp"
                                local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                                local clients = vim.lsp.get_active_clients()
                                if next(clients) == nil then
                                    return msg
                                end
                                for _, client in ipairs(clients) do
                                    local filetypes = client.config.filetypes
                                    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                                        return client.name
                                    end
                                end
                                return msg
                            end,
                            icon = " LSP:",
                        },
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                            source = function()
                                local gitsigns = vim.b.gitsigns_status_dict
                                if gitsigns then
                                    return {
                                        added = gitsigns.added,
                                        removed = gitsigns.removed,
                                        modified = gitsigns.changed,
                                    }
                                end
                            end,
                        },
                    },
                    lualine_y = {
                        {
                            "progresss",
                            separator = " ",
                            padding = { left = 1, right = 0 },
                        },
                        {
                            "location",
                            padding = { left = 1, right = 1 },
                            icon = "",
                            fmt = function(str)
                                return str:lower()
                            end,
                        },
                    },
                    lualine_z = {
                        {
                            function()
                                return " " .. os.date("%H:%M")
                            end,
                        },
                    },
                },
                extensions = {
                    "neo-tree",
                    "toggleterm",
                    "symbols-outline",
                    "quickfix",
                    "lazy",
                    "man",
                    "mason",
                    "trouble",
                    "nvim-dap-ui",
                },
            })
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = { enabled = true },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        },
        main = "ibl",
    },

    {
        "echasnovski/mini.indentscope",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "NeogitPopup",
                    "Trouble",
                    "alpha",
                    "dashboard",
                    "floaterm",
                    "help",
                    "lazy",
                    "lazyterm",
                    "mason",
                    "neo-tree",
                    "neogit",
                    "notify",
                    "toggleterm",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    { -- show white space
        "johnfrankmorgan/whitespace.nvim",
        config = function()
            require("whitespace-nvim").setup({
                highlight = "WarningMsg",
                ignored_filetype = { "TelescopePrompt", "Trouble", "help" },
                ignore_terminal = true,
            })
        end,
        lazy = false,
    },
    { -- scroll bar
        "lewis6991/satellite.nvim",
        cond = function()
            return vim.fn.has("nvim-0.10") == 1
        end,
        opts = {
            winblend = 0,
        },
    },

    { -- bufferline
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        keys = {
            { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
            { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
            { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
            { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
        },
        opts = {
            options = {
                separator_style = "slope",
                diagnostics = "nvim_lsp",
                always_show_bufferline = true,
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local s = " "
                    for e, n in pairs(diagnostics_dict) do
                        local sym = e == "error" and " " or (e == "warning" and " " or "")
                        s = s .. " " .. n .. " " .. sym
                    end
                    return s
                end,
            },
        },
    },

    { --window
        "anuvyklack/windows.nvim",
        dependencies = {
            "anuvyklack/middleclass",
        },
        config = function()
            vim.o.winwidth = 10
            vim.o.winminwidth = 10
            vim.o.equalalways = false
            require("windows").setup()
        end,
    },
}
