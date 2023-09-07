return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		on_attach = function(buffer)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
			end

            -- stylua: ignore start
            map("n", "]h", gs.next_hunk, "Next Hunk (GitSigns)")
            map("n", "[h", gs.prev_hunk, "Previous Hunk (GitSigns)")
            map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk (GitSigns)")
            map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk (GitSigns)")
            map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer (GitSigns)")
            map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk (GitSigns)")
            map("n", "<leader>ghR", gs.reset_buffer, "Reset Hunk (GitSigns)")
            map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk (GitSigns)")
            map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line (GitSigns)")
            map("n", "<leader>ghB", function() gs.toggle_current_line_blame() end, "Toggle Current Line Blame (GitSigns)")
            map("n", "<leader>ghd", gs.diffthis, "Diff This (GitSigns)")
            map("n", "<leader>ghx", "<cmd>wincmd p | q<cr>", "Exit Diff (Gitsigns)")
            map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~ (GitSigns)")
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk (GitSigns)")
		end,
	},
}
