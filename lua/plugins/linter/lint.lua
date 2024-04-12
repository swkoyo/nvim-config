return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFIle" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			-- javascript = { "eslint_d" },
			-- javascriptreact = { "eslint_d" },
			-- typescript = { "eslint_d" },
			-- typescriptreact = { "eslint_d" },
			-- astro = { "eslint_d" },
			dockerfile = { "hadolint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
