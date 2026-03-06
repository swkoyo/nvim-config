return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
				highlight = "IblIndent",
			},
			scope = { enabled = false }, -- let mini.indentscope handle this
		},
		config = function(_, opts)
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "IblIndent", { fg = "#2a2a37" }) -- very subtle
			end)
			require("ibl").setup(opts)
		end,
	},
	{
		"nvim-mini/mini.indentscope",
		version = "*",
		config = function()
			local indentscope = require("mini.indentscope")
			indentscope.setup({
				symbol = "│",
				options = { try_as_border = true },
				draw = {
					delay = 0,
					animation = indentscope.gen_animation.none(),
				},
			})
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#ff9e3b" })
		end,
	},
}
