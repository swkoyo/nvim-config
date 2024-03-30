return {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
        vim.g.navic_silence = true
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client.server_capabilities.documentSymbolProvider then
                    require("nvim-navic").attach(client, event.buf)
                end
			end,
		})
    end,
    opts = function()
        return {
            separator = " > ",
            highlight = true,
            depth_limit = 5,
            icons = require("core.constants").icons.kinds
        }
    end
}
