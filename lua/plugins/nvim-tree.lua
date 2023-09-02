return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	keys = {
		{ "<leader>fe", ":NvimTreeToggle<cr>", desc = "Explorer NvimTree (root dir)" },
	},
	opts = {
		sort_by = "case_sensitive",
		renderer = {
			group_empty = true,
		},
		filters = {
			dotfiles = false,
		},
		actions = {
			open_file = {
				quit_on_open = true,
			},
		},
	},
}
