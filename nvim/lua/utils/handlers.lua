local M = {}

M.capabilities = require("cmp_nvim_lsp").default_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

M.general_on_attach = function(client, bufnr)
    if client.resolved_capabilities.completion then
        cmp_nvim_lsp.on_attach(client, bufnr)
    end
end
M.setup = function()
    local signs = {

        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    local border = {
        { "🭽", "FloatBorder" },
        { "▔", "FloatBorder" },
        { "🭾", "FloatBorder" },
        { "▕", "FloatBorder" },
        { "🭿", "FloatBorder" },
        { "▁", "FloatBorder" },
        { "🭼", "FloatBorder" },
        { "▏", "FloatBorder" },
    }
    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        -- virtual_text = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        virtual_text = {
            -- update_in_insert = true,
            severity_sort = true,
            prefix = " ",
            source = "if_many", -- Or "always"
            format = function(diag)
                return diag.message .. "blah"
            end,
        },
        signs = {
            active = signs, -- show signs
        },
        float = {
            focusable = true,
            --style = "minimal",
            border = border,
            source = "always",
            header = "",
            prefix = "",
        },
        code_lens_refresh = true,
        document_highlight = true,
    }
    vim.diagnostic.config(config)
end

local flags = {
    debounce_text_changes = 150,
}
M.on_attach = function(client)
    client.flags = flags
    local illuminate = require("illuminate")
    illuminate.on_attach(client)
end


return M
