return {
    {
        "s1n7ax/nvim-window-picker",
        name = "window-picker",
        event = "VeryLazy",
        version = "2.*",
        config = function()
            require("window-picker").setup()
        end,
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {
            modes = {
                search = {
                    enabled = false,
                    highlight = {
                        backdrop = true,
                    },
                },
                char = {
                    jump_labels = true,
                },
            },
        },

        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            -- {
            --     "S",
            --     mode = { "n", "x", "o" },
            --     function()
            --         require("flash").treesitter()
            --     end,
            --     desc = "Flash Treesitter",
            -- },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
    },

    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
            {
                "tomasky/bookmarks.nvim",
                event = "VimEnter",
                config = function() end,
            },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = vim.fn.executable("make") == 1 and "make"
                    or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
                enabled = vim.fn.executable("make") == 1 or vim.fn.executable("cmake") == 1,
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
        },
        config = function()
            local function flash(prompt_bufnr)
                require("flash").jump({
                    pattern = "^",
                    label = { after = { 0, 0 } },
                    search = {
                        mode = "search",
                        exclude = {
                            function(win)
                                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                            end,
                        },
                    },
                    action = function(match)
                        local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                        picker:set_selection(match.pos[1] - 1)
                    end,
                })
            end
            local telescope = require("telescope")
            telescope.defaults = vim.tbl_deep_extend("force", telescope.defaults or {}, {
                mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
            })
            vim.cmd([[
                    augroup _fold_bug_solution
                        autocmd!
                        autocmd Bufread * autocmd BufWinEnter * ++once normal! zx
                    augroup end

                    ]])
            telescope.setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({
                            -- even more opts
                        }),
                    },
                    file_browser = {
                        theme = "ivy",
                        hijack_netrw = true,
                    },
                    live_grep_raw = {
                        auto_quoting = true, -- enable/disable auto-quotingtele
                    },
                },
                telescope.load_extension("ui-select"),
                telescope.load_extension("live_grep_args"),
                telescope.load_extension("notify"),
            })
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        deactivate = function()
            vim.cmd([[Neotree close]])
        end,
        init = function()
            if vim.fn.argc(-1) == 1 then
                local stat = vim.uv.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
        end,

        config = function()
            require("neo-tree").setup({
                sources = { "filesystem", "buffers", "git_status", "document_symbols" },
                close_if_last_window = true,
                popup_border_style = "rounded",
                enable_git_status = true,
                enable_diagnostics = true,
                filesystem = {
                    hide_dotfiles = false,
                    hide_hidden = false,
                    bind_to_cwd = false,
                    follow_current_file = { enabled = true },
                    use_libuv_file_watcher = true,
                    visible = true,
                    hide_gitignored = true,
                },
                window = {
                    width = 30,
                    close_if_last_window = true,
                    popup_border_style = "rounded",
                    enable_git_status = true,
                    enable_diagnostics = true,
                    mappings = {
                        ["<space>"] = "none",
                        ["Y"] = {
                            function(state)
                                local node = state.tree:get_node()
                                local path = node:get_id()
                                vim.fn.setreg("+", path, "c")
                            end,
                            desc = "copy path to clipboard",
                        },
                    },
                },
                default_component_configs = {
                    indent = {
                        indent_size = 2,
                        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                        expander_collapsed = "",
                        expander_expanded = "",
                        expander_highlight = "NeoTreeExpander",
                    },
                },
                source_selector = {
                    winbar = true,
                    show_scrolled_off_parent_node = false, -- this will replace the tabs with the parent path
                },
            })
        end,
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
    },

    {
        "folke/which-key.nvim",
        event = "UIEnter",
        config = function()
            local which = require("which-key")
            which.add({
                { --Group
                    --Useful Support
                    { "<leader>s", group = "Support", icon = " " },
                    { "<leader>st", "<cmd>TranslateW<CR>", desc = "Translate Word" },
                    { "<leader>ss", "<cmd>BrowseInputSearch<CR>", desc = "Web Search" },
                    { "<leader>sb", "<cmd>BrowseBookmarks<CR>", desc = "Bookmark Search" },
                    { "<leader>sr", "<cmd>GrugFar<CR>", desc = "Replace Text" },

                    --Markdown
                    { "<leader>m", group = "Markdown", icon = "󰍔 " },
                    { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Preview" },
                    { "<leader>mc", "<cmd>GenTocGFM<CR>", desc = "Generate a content" },
                    { "<leader>mr", "<cmd>RemoveToc<CR>", desc = "Remove table" },
                    { "<leader>mu", "<cmd>UpdateToc<CR>", desc = "Update content" },
                    { "<leader>mt", "<cmd>TableModeToggle<CR>", desc = "Creat Table" },

                    --Git
                    { "<leader>g", group = "Git" },
                    { "<leader>gf", "<cmd>DiffviewFileHistory<CR>", desc = "File History" },
                    { "<leader>gp", "<cmd>DiffviewOpen<CR>", desc = "Diff Project" },
                    { "<leader>gn", "<cmd>lua require 'gitsigns'.next_hunk()<CR>", desc = "Next Hunk" },
                    { "<leader>gN", "<cmd>lua require 'gitsigns'.prev_hunk()<CR>", desc = "Prev Hunk" },
                    { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<CR>", desc = "Blame" },
                    { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<CR>", desc = "Reset Hunk" },
                    { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<CR>", desc = "Reset Buffer" },
                    { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<CR>", desc = "Stage Hunk" },
                    { "<leader>gS", "<cmd>lua require 'gitsigns'.stage_buffer()<CR>", desc = "Stage Hunk" },
                    { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<CR>", desc = "Undo Stage Hunk" },
                    { "<leader>go", "<cmd>Telescope git_status<CR>", desc = "Open changed file" },
                    { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Checkout branch" },
                    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Checkout commit" },
                    { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<CR>", desc = "Diff" },
                    { "<leader>gL", "<cmd>LazyGit<CR>", desc = "Open LazyGit" },

                    --LSP
                    { "<leader>l", group = "LSP", icon = "󰙳 " },
                    { "<leader>la", "<cmd>Lspsaga code_action<CR>", desc = "Code Action" },
                    { "<leader>lc", "<cmd>Lspsaga incoming_calls ++normal<CR>", desc = "Callhierarchy" },
                    { "<leader>ld", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
                    { "<leader>lh", "<cmd>Lspsaga hover_doc ++keep<CR>", desc = "Hover" },
                    {
                        "<leader>lw",
                        "<cmd>Telescope lsp_workspace_diagnostics<CR>",
                        desc = "Workspace Diagnostics",
                    },
                    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
                    { "<leader>lj", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next Diagnostic" },
                    { "<leader>lk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Prev Diagnostic" },
                    { "<leader>lg", "<cmd>Lspsaga goto_definition<CR>", desc = "Go to Definition" },
                    { "<leader>lr", "<cmd>Lspsaga rename<CR>", desc = "Rename" },
                    { "<leader>lp", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek Definition" },
                    { "<leader>lF", "<cmd>Lspsaga finder def+ref<CR>", desc = "Reference" },
                    { "<leader>lu", "<cmd>Trouble lsp_references<CR>", desc = "Usage" },
                    {
                        "<leader>lq",
                        "<cmd>lua vim.diagnostic.setloclist()<CR>",
                        desc = "Set diagnostic list",
                    },
                    { "<leader>lo", "<cmd>Outline<CR>", desc = "Outline" },

                    --Telescope
                    { "<leader>f", group = "Telescope" },
                    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find_files" },
                    { "<leader>fc", "<cmd>Telescope colorscheme<CR>", desc = "Colorscheme" },
                    { "<leader>ft", "<cmd>Telescope live_grep<CR>", desc = "Search words" },
                    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
                    { "<leader>fC", "<cmd>Telescope commands<CR>", desc = "Commands" },
                    {
                        "<leader>fh",
                        "<cmd>Telescope highlights<CR>",
                        desc = "Find highlight groups",
                    },
                    { "<leader>fr", "<cmd>Telescope registers<CR>", desc = "Registers" },
                    { "<leader>fl", "<cmd>Legendars<CR>", desc = "Details of commands" },
                    { "<leader>fn", "<cmd>Telescope notify<CR>", desc = "Notifications" },

                    --CMake
                    { "<leader>c", group = "CMake", icon = " " },
                    { "<leader>cg", "<cmd>CMakeGenerate<CR>", desc = "Create Project" },
                    { "<leader>cb", "<cmd>CMakeQuickBuild<CR>", desc = "Build Project" },
                    { "<leader>cs", "<cmd>CMakeSelectLaunchTarget<CR>", desc = "Select Target" },
                    { "<leader>cr", "<cmd>CMakeRun<CR>", desc = "Run Project" },

                    --CompetiTest
                    { "<leader>C", group = "CompetiTest", icon = " " },
                    { "<leader>Ca", "<cmd>CompetiTest receive testcases<CR>", desc = "Receive Test cases" },
                    { "<leader>Cd", "<cmd>CompetiTest delete<CR>", desc = "Delete Test cases" },
                    { "<leader>Cr", "<cmd>CompetiTest run<CR>", desc = "Run Test cases" },

                    --Debug
                    { "<leader>D", group = "Debug" },
                    { "<leader>Dt", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "Toggle Breakpoint" },
                    { "<leader>Db", "<cmd>lua require'dap'.step_back()<CR>", desc = "Step Back" },
                    { "<leader>Dc", "<cmd>lua require'dap'.continue()<CR>", desc = "Continue" },
                    { "<leader>DC", "<cmd>lua require'dap'.run_to_cursor()<CR>", desc = "Run To Cursor" },
                    { "<leader>Dg", "<cmd>lua require'dap'.session()<CR>", desc = "Get Session" },
                    { "<leader>Di", "<cmd>lua require'dap'.step_into()<CR>", desc = "Step Into" },
                    { "<leader>Do", "<cmd>lua require'dap'.step_over()<CR>", desc = "Step Over" },
                    { "<leader>Du", "<cmd>lua require'dap'.step_out()<CR>", desc = "Step Out" },
                    { "<leader>Dp", "<cmd>lua require'dap'.pause()<CR>", desc = "Pause" },
                    { "<leader>Dr", "<cmd>lua require'dap'.repl.toggle()<CR>", desc = "Toggle Repl" },
                    { "<leader>Ds", "<cmd>lua require'dap'.continue()<CR>", desc = "Start" },
                    { "<leader>Dq", "<cmd>lua require'dap'.close()<CR>", desc = "Quit" },
                    { "<leader>DU", "<cmd>lua require'dapui'.toggle()<CR>", desc = "Toggle UI" },

                    --Trouble
                    { "<leader>t", group = "Trouble", icon = "󰋗 " },
                    { "<leader>tt", "<cmd>Trouble<CR>", desc = "ToggleTrouble" },
                    { "<leader>td", "<cmd>Trouble diagnostics<CR>", desc = "Diagnostics" },
                    { "<leader>tq", "<cmd>Trouble quickfix<CR>", desc = "Quick Fix" },
                    { "<leader>tc", "<cmd>TodoTrouble<CR>", desc = "Todo-comment" },

                    --Buffers
                    { "<leader>b", group = "Buffers" },
                    { "<leader>bp", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
                    { "<leader>bP", "<Cmd>BufferLinePickClose<CR>", desc = "Close a Buffer" },
                    {
                        "<leader>bo",
                        "<Cmd>BufferLineCloseOthers<CR>",
                        desc = "Delete Other Buffers",
                    },
                    {
                        "<leader>br",
                        "<Cmd>BufferLineCloseRight<CR>",
                        desc = "Delete Buffers to the Right",
                    },
                    {
                        "<leader>bl",
                        "<Cmd>BufferLineCloseLeft<CR>",
                        desc = "Delete Buffers to the Left",
                    },

                    --Window
                    { "<leader>w", group = "Window" },
                    { "<leader>wm", "<Cmd>WindowsMaximize<CR>", desc = "Window Maximize" },
                    {
                        "<leader>wv",
                        "<Cmd>WindowsMaximizeVertically<CR>",
                        desc = "Window Vertically Maximize",
                    },
                    {
                        "<leader>wh",
                        "<Cmd>WindowsMaximizeHorizontally<CR>",
                        desc = "Window Horizontally Maximize",
                    },
                    { "<leader>we", "<Cmd>WindowsEqualize<CR>", desc = "Window Equalize" },
                    {
                        "<leader>ws",
                        "<Cmd>vsplit<CR>",
                        desc = "Window Vertical Split",
                    },
                    { "<leader>wV", "<Cmd>split<CR>", desc = "Window Split" },
                },

                {
                    mode = { "n" },
                    { "<leader>a", "<cmd>Alpha<CR>", desc = "Welcome", icon = "󱠞 " },
                    { "<leader>r", "<cmd>Telescope oldfiles<CR>", desc = "Open Recent File" },
                    { "<leader>p", "<cmd>Lazy<CR>", desc = "Plugins", icon = "󰒲 " },
                    { "<leader>d", "<cmd>bdelete<CR>", desc = "Close Current Buffer", icon = "󰛉 " },
                    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorer", icon = " " },
                    { "<leader>q", "<cmd>q!<CR>", desc = "Quit" },
                    { "<leader>h", "<cmd>nohlsearch<CR>", desc = "No Highlight", icon = " " },
                },

                {
                    mode = { "v" },
                    { "<leader>/", "<Plug>(comment_toggle_linewise_visual)", desc = "Comment" },
                    { "<leader>t", "<cmd>TranslateW<CR>", desc = "Translate" },
                },
            })
        end,
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        opts = { use_diagnostic_signs = true },
    },

    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        opts = {},
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = { options = vim.opt.sessionoptions:get() },
    },

    --Cmake
    {
        "Civitasv/cmake-tools.nvim",
        lazy = true,
        ft = { "cpp", c },
        init = function()
            local loaded = false
            local function check()
                local cwd = vim.uv.cwd()
                if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
                    require("lazy").load({ plugins = { "cmake-tools.nvim" } })
                    loaded = true
                end
            end
            check()
            vim.api.nvim_create_autocmd("DirChanged", {
                callback = function()
                    if not loaded then
                        check()
                    end
                end,
            })
        end,
        opts = {
            cmake_command = "cmake", -- this is used to specify cmake command path
            ctest_command = "ctest", -- this is used to specify ctest command path
            cmake_regenerate_on_save = true, -- auto generate when save CMakeLists.txt
            cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
            cmake_build_options = {}, -- this will be passed when invoke `CMakeBuild`
            -- support macro expansion:
            --       ${kit}
            --       ${kitGenerator}
            --       ${variant:xx}
            cmake_build_directory = "out/${variant:buildType}", -- this is used to specify generate directory for cmake, allows macro expansion, relative to vim.loop.cwd()
            cmake_soft_link_compile_commands = true, -- this will automatically make a soft link from compile commands file to project root dir
            cmake_compile_commands_from_lsp = false, -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
            cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
            cmake_variants_message = {
                short = { show = true }, -- whether to show short message
                long = { show = true, max_length = 40 }, -- whether to show long message
            },
            cmake_dap_configuration = { -- debug settings for cmake
                name = "cpp",
                type = "codelldb",
                request = "launch",
                stopOnEntry = false,
                runInTerminal = true,
                console = "integratedTerminal",
            },
            cmake_executor = { -- executor to use
                name = "quickfix", -- name of the executor
                opts = {}, -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
                default_opts = { -- a list of default and possible values for executors
                    quickfix = {
                        show = "always", -- "always", "only_on_error"
                        position = "belowright", -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
                        size = 20,
                        encoding = "utf-8", -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
                        auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
                    },
                    toggleterm = {
                        direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
                        close_on_exit = false, -- whether close the terminal when exit
                        auto_scroll = true, -- whether auto scroll to the bottom
                    },
                    overseer = {
                        new_task_opts = {
                            strategy = {
                                "toggleterm",
                                direction = "horizontal",
                                autos_croll = true,
                                quit_on_exit = "success",
                            },
                        }, -- options to pass into the `overseer.new_task` command
                        on_new_task = function(task)
                            require("overseer").open({ enter = false, direction = "right" })
                        end, -- a function that gets overseer.Task when it is created, before calling `task:start`
                    },
                    terminal = {
                        name = "Main Terminal",
                        prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
                        split_direction = "horizontal", -- "horizontal", "vertical"
                        split_size = 35,

                        -- Window handling
                        single_terminal_per_instance = true, -- Single viewport, multiple windows
                        single_terminal_per_tab = true, -- Single viewport per tab
                        keep_terminal_static_location = true, -- Static location of the viewport if avialable

                        -- Running Tasks
                        start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
                        focus = false, -- Focus on terminal when cmake task is launched.
                        do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
                    }, -- terminal executor uses the values in cmake_terminal
                },
            },
            cmake_runner = { -- runner to use
                name = "terminal", -- name of the runner
                opts = {}, -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
                default_opts = { -- a list of default and possible values for runners
                    quickfix = {
                        show = "always", -- "always", "only_on_error"
                        position = "belowright", -- "bottom", "top"
                        size = 20,
                        encoding = "utf-8",
                        auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
                    },
                    toggleterm = {
                        direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
                        close_on_exit = false, -- whether close the terminal when exit
                        auto_scroll = true, -- whether auto scroll to the bottom
                    },
                    overseer = {
                        new_task_opts = {
                            strategy = {
                                "toggleterm",
                                direction = "horizontal",
                                autos_croll = true,
                                quit_on_exit = "success",
                            },
                        }, -- options to pass into the `overseer.new_task` command
                        on_new_task = function(task) end, -- a function that gets overseer.Task when it is created, before calling `task:start`
                    },
                    terminal = {
                        name = "Main Terminal",
                        prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
                        split_direction = "horizontal", -- "horizontal", "vertical"
                        split_size = 35,

                        -- Window handling
                        single_terminal_per_instance = true, -- Single viewport, multiple windows
                        single_terminal_per_tab = true, -- Single viewport per tab
                        keep_terminal_static_location = true, -- Static location of the viewport if avialable

                        -- Running Tasks
                        start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
                        focus = false, -- Focus on terminal when cmake task is launched.
                        do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
                    },
                },
            },
            cmake_notifications = {
                runner = { enabled = true },
                executor = { enabled = true },
                spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
                refresh_rate_ms = 100, -- how often to iterate icons
            },
        },
    },

    --DAP
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        event = { "VeryLazy" },
        dependencies = {
            "mfussenegger/nvim-dap-python",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/neotest",
            "nvim-neotest/neotest-python",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require("utils.dap")
        end,
    },

    -- fold
    {
        "kevinhwang91/nvim-ufo",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        dependencies = {
            "kevinhwang91/promise-async",
        },

        config = function()
            -- Option 2: nvim lsp as LSP client
            -- Tell the server the capability of foldingRange,
            -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }
            local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
            for _, ls in ipairs(language_servers) do
                require("lspconfig")[ls].setup({
                    capabilities = capabilities,
                    -- you can add other fields for setting up lsp server in this table
                })
            end

            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (" 󰁂 %d "):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end

            -- global handler
            -- `handler` is the 2nd parameter of `setFoldVirtTextHandler`,
            -- check out `./lua/ufo.lua` and search `setFoldVirtTextHandler` for detail.

            require("ufo").setup({
                open_fold_hl_timeout = 0,
                fold_virt_text_handler = handler,
                preview = {
                    win_config = {
                        border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
                        winblend = 0,
                        winhighlight = "Normal:LazyNormal",
                    },
                    mappings = {
                        scrollU = "<C-u>",
                        scrollD = "<C-d>",
                        jumpTop = "[",
                        jumpBot = "]",
                    },
                },
            })
            vim.keymap.set("n", "zR", require("ufo").openAllFolds)
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
            vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
            vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                interval = 1000,
                follow_files = true,
            },
            attach_to_untracked = true,
            current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                delay = 100,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000,
            preview_config = {
                -- Options passed to nvim_open_win
                border = "rounded",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
            -- keymapping
            on_attach = function(bufnr)
                local function map(mode, lhs, rhs, opts)
                    opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
                    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
                end
            end,
        },
    },

    {
        "sindrets/diffview.nvim",
        event = "VeryLazy",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = function()
            require("diffview").setup({})
        end,
    },

    {
        "nacro90/numb.nvim",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    },

    { -- auto save
        "Pocco81/auto-save.nvim",
        lazy = true,
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        config = function()
            local auto_save = require("auto-save")
            auto_save.setup({
                enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
                execution_message = {
                    message = function() -- message to print on save
                        return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
                    end,
                    dim = 0.18, -- dim the color of `message`
                    cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
                },
                trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
                -- function that determines whether to save the current buffer or not
                -- return true: if buffer is ok to be saved
                -- return false: if it's not ok to be saved
                condition = function(buf)
                    local fn = vim.fn
                    local utils = require("auto-save.utils.data")

                    if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
                        return true -- met condition(s), can save
                    end
                    return false -- can't save
                end,
                write_all_buffers = false, -- write all buffers when the current one meets `condition`
                debounce_delay = 135, -- saves the file at most every `debounce_delay` milliseconds
                callbacks = { -- functions to be executed at different intervals
                    enabling = nil, -- ran when enabling auto-save
                    disabling = nil, -- ran when disabling auto-save
                    before_asserting_save = nil, -- ran before checking `condition`
                    before_saving = nil, -- ran before doing the actual save
                    after_saving = nil, -- ran after doing the actual save
                },
            })
        end,
    },

    {
        "numToStr/Comment.nvim",
        lazy = true,
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        config = function()
            require("Comment").setup({

                pre_hook = function(ctx)
                    local U = require("Comment.utils")

                    local status_utils_ok, utils = pcall(require, "ts_context_commentstring.utils")
                    if not status_utils_ok then
                        return
                    end

                    local location = nil
                    if ctx.ctype == U.ctype.block then
                        location = utils.get_cursor_location()
                    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                        location = utils.get_visual_start_location()
                    end

                    local status_internals_ok, internals = pcall(require, "ts_context_commentstring.internals")
                    if not status_internals_ok then
                        return
                    end

                    return internals.calculate_commentstring({
                        key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
                        location = location,
                    })
                end,
            })
        end,
    },

    {
        "xeluxee/competitest.nvim",
        lazy = true,
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        ft = "cpp",
        config = function()
            require("competitest").setup({
                compile_command = {
                    cpp = { exec = "g++", args = { "-std=c++20", "$(FNAME)", "-o", "$(FNOEXT)" } },
                },
                runner_ui = {
                    interface = "popup",
                },
                split_ui = {
                    position = "right",
                    relative_to_editor = true,
                    total_width = 0.3,
                    vertical_layout = {
                        { 1, "tc" },
                        { 1, { { 1, "so" }, { 1, "eo" } } },
                        { 1, { { 1, "si" }, { 1, "se" } } },
                    },
                    total_height = 0.4,
                    horizontal_layout = {
                        { 2, "tc" },
                        { 3, { { 1, "so" }, { 1, "si" } } },
                        { 3, { { 1, "eo" }, { 1, "se" } } },
                    },
                },
                view_output_diff = true,
            })
        end,
    },
    -- web search
    {
        "lalitmee/browse.nvim",
        event = "VimEnter",
        config = function()
            local browse = require("browse")
            browse.setup({
                provider = "bing",
            })
            local bookmarks = {
                "https://www.chrisatmachine.com/",
                "https://github.com/christianchiarulli",
                "https://github.com/rockerBOO/awesome-neovim",
                "https://doc.rust-lang.org/book/",
                "https://aur.archlinux.org/packages/",
                "https://www.bilibili.com",
                "https://www.google.com",
                "https://www.youtube.com",
                "https://www.bing.com",
                "https://markdown.com.cn/basic-syntax/",
                "https://atcode.jp",
                "https://blog,csdn.net",
                "https://leetcode.cn",
                "https://www.acwing.com",
                "https://luogu.com.cn",
                "https://zh.cppreference.com/w/cpp",
                "https://github.com/neovim/neovim",
                "https://neovim.discourse.group/",
            }

            local function command(name, rhs, opts)
                opts = opts or {}
                vim.api.nvim_create_user_command(name, rhs, opts)
            end

            command("BrowseInputSearch", function()
                browse.input_search()
            end, {})

            command("Browse", function()
                browse.browse({ bookmarks = bookmarks })
            end, {})

            command("BrowseBookmarks", function()
                browse.open_bookmarks({ bookmarks = bookmarks })
            end, {})

            command("BrowseDevdocsSearch", function()
                browse.devdocs.search()
            end, {})

            command("BrowseDevdocsFiletypeSearch", function()
                browse.devdocs.search_with_filetype()
            end, {})

            command("BrowseMdnSearch", function()
                browse.mdn.search()
            end, {})

            local opts = { noremap = true, silent = true }
            local keymap = vim.api.nvim_set_keymap
        end,
    },

    -- { -- Search and Replace files
    --     "nvim-pack/nvim-spectre",
    --     build = false,
    --     cmd = "Spectre",
    --     opts = { open_cmd = "noswapfile vnew" },
    -- },

    {
        "MagicDuck/grug-far.nvim",
        config = function()
            require("grug-far").setup({})
        end,
    },

    { -- terminal
        "akinsho/toggleterm.nvim",
        lazy = true,
        event = { "VeryLazy" },
        config = function()
            require("toggleterm").setup()
        end,
    },

    { -- outline
        "hedyhli/outline.nvim",
        lazy = true,
        cmd = { "Outline", "OutlineOpen" },
        opts = {
            -- Your setup opts here
        },
    },

    { -- Translator
        "voldikss/vim-translator",
        lazy = true,
        cmd = { "TranslateW" },
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
    },

    {
        "echasnovski/mini.align",
        event = "VeryLazy",
        config = function()
            require("mini.align").setup()
        end,
    },

    {
        "chrisgrieser/nvim-various-textobjs",
        event = { "VimEnter" },
        config = function()
            require("various-textobjs").setup()
        end,
    },

    { -- accelerated jk
        "rhysd/accelerated-jk",
        lazy = true,
        event = { "VimEnter" },
    },

    { -- generate function brief
        "vim-scripts/DoxygenToolkit.vim",
        event = { "InsertEnter" },
        lazy = true,
    },

    { -- select function region
        "terryma/vim-expand-region",
    },

    { -- Lazygit integration
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
    },

    { -- show color
        "norcalli/nvim-colorizer.lua",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        config = function()
            require("colorizer").setup()
        end,
    },

    {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
        opts = {
            rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
        },
    },

    {
        "tzachar/highlight-undo.nvim",
        opts = {
            duration = 300,
            undo = {
                hlgroup = "HighlightUndo",
                mode = "n",
                lhs = "u",
                map = "undo",
                opts = {},
            },
            redo = {
                hlgroup = "HighlightRedo",
                mode = "n",
                lhs = "<C-r>",
                map = "redo",
                opts = {},
            },
            highlight_for_count = true,
        },
    },
}
