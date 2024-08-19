return {
	"mistricky/codesnap.nvim",
	build = "make build_generator",
	keys = {
		{
			"<leader>cc",
			"<cmd>CodeSnap<cr>",
			mode = "x",
			desc = "Save [C]ode snapshot to [C]lipboard",
		},
		{
			"<leader>cC",
			"<cmd>CodeSnapHighlight<cr>",
			mode = "x",
			desc = "Save [C]ode snapshot to [C]lipboard (Highlight)",
		},
	},
	opts = {
		has_breadcrumbs = true,
		bg_theme = "default",
		has_line_number = true,
		watermark = "",
		mac_window_bar = false,
		code_font_family = "Iosevka Nerd Font",
		bg_x_padding = 0,
		bg_y_padding = 0,
	},
}
