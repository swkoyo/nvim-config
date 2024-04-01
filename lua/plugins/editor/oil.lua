return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		default_file_explorer = true,
		view_options = {
			show_hidden = true,
		},
	},
	config = function(_, opts)
		require("oil").setup(opts)
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		vim.keymap.set(
			"n",
			"<leader>fe",
			"<cmd>lua require('oil').open_float()<cr>",
			{ desc = "Open [F]ile [E]xplorer" }
		)
	end,
}
