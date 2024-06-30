local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")

require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
local adapter = require("diffview.vcs.adapter")

require("neotest").setup({
    adapters = {
        require("neotest-python") ({
            dap = {
                justMyCode = false,
                console = "intergratedTerminal",
            },
            args = {"--log-level" , "DEBUG" , "--quiet"},
            runner = "pytest",
        })
    },
})
