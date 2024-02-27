local ignore_files = {
	"help",
	"NvimTree",
	"Trouble",
	"lazy",
	"dashboard",
	"mason",
	"notify",
	"toggleterm",
}

return {
	{
		"lukas-reineke/indent-blankline.nvim",
        main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
            indent = {
                char = "|",
				tab_char = "|",
            },
            exclude = {
                filetypes = ignore_files
            },
			scope = {
				enabled = false
			}
		},
	},
	{
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- symbol = "▏",
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = ignore_files,
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
}
