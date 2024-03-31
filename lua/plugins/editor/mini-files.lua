return {
	"echasnovski/mini.files",
	version = "*",
	cond = false,
	keys = {
		{
			"<leader>fe",
			"<cmd>lua require('mini.files').open()<cr>",
			{ desc = "Open [F]ile [E]xplorer" },
		},
	},
	opts = {
		options = {
			use_as_default_explorer = true,
		},
		mappings = {
			go_in_plus = "<CR>",
		},
	},
	config = function(_, opts)
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		require("mini.files").setup(opts)
	end,
}
