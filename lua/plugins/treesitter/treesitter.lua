return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		auto_install = true,
		ensure_installed = {
			"bash",
			"c",
			"cpp",
			"dockerfile",
			"go",
			"rust",
			"toml",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"vim",
			"vimdoc",
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
		vim.filetype.add({
			pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
		})
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "hyprlang",
			callback = function(event)
				vim.bo[event.buf].commentstring = "# %s"
			end,
		})
	end,
}
