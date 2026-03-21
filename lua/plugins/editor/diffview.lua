return {
	"sindrets/diffview.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
	keys = {
		{
			"<leader>ghd",
			function()
				local lib = require("diffview.lib")
				local view = lib.get_current_view()
				if view then
					vim.cmd("DiffviewClose")
				else
					vim.cmd("DiffviewOpen -- %")
				end
			end,
			desc = "Toggle Diff (current file)",
		},
		{
			"<leader>ghD",
			function()
				local lib = require("diffview.lib")
				local view = lib.get_current_view()
				if view then
					vim.cmd("DiffviewClose")
				else
					vim.cmd("DiffviewFileHistory %")
				end
			end,
			desc = "Toggle File History",
		},
		{
			"<leader>ghx",
			"<cmd>DiffviewClose<cr>",
			desc = "Close Diffview",
		},
	},
}
