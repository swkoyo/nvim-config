return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	cmd = { "TSUpdateSync" },
    keys = {
        { "<c-space>", desc = "Increment selection" },
        { "<bs>", desc = "Decrement selection", mode = "x" }
    },
	opts = {
		auto_install = true,
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
		ensure_installed = {
			"lua",
            "markdown",
            "regex",
		},
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = false,
                node_decremental = "<bs>"
            }
        }
	},
    -- config = function(_, opts)
    --     if type(opts.ensure_installed) == "table" then
    --         local added = {}
    --         opts.ensure_installed = vim.tbl_filter(function(lang)
    --             if added[lang] then
    --                 return false
    --             end
    --             return true
    --         end, opts.ensure_installed)
    --     end
    --
    --     require("nvim-treesitter.configs").setup(opts)
    --
    --     if loaded_textobjects then
    --
    --     end
    -- end
}
