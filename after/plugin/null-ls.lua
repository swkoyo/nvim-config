require("mason-null-ls").setup({
	ensure_installed = {
		"eslint_d",
		"prettierd",
		"stylua",
		"black",
		"ruff",
		"ruff_lsp",
		"goimports",
		"shfmt",
		"fixjson",
		"clang_format",
		"yamlfmt",
	},
	handlers = {},
})

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.ruff
	}
})

--
-- null_ls.setup({
-- 	sources = {
-- 		-- Replace these with the tools you have installed
-- 		-- make sure the source name is supported by null-ls
-- 		-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
-- 		null_ls.builtins.diagnostics.eslint_d,
-- 		null_ls.builtins.formatting.prettierd,
-- 		null_ls.builtins.formatting.stylua,
-- 		null_ls.builtins.formatting.black,
-- 		null_ls.builtins.formatting.isort,
-- 		null_ls.builtins.formatting.goimports,
--         null_ls.builtins.formatting.shfmt,
-- 	},
-- })
