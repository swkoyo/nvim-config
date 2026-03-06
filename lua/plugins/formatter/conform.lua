return {
	"stevearc/conform.nvim",
	opts = {
		format = {
			timeout_ms = 3000,
			async = true,
			quiet = false,
			lsp_fallback = true,
		},
		notify_on_error = true,
		format_on_save = function(bufnr)
			local ignore_filetypes = { "python", "terraform", "yaml", "graphql" }
			if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
				return
			end
			return {
				timeout_ms = 500,
				lsp_fallback = "fallback",
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			rust = { "rustfmt" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			graphql = { "prettierd" },
			astro = { "prettierd" },
			-- python = { "ruff_format", "ruff_organize_imports" },
			python = { "ruff_format" },
			-- python = { "black" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			cs = { "csharpier" },
			ruby = { "rubocop" },
			go = { "gofmt", "goimports" },
			templ = { "templ" },
			json = { "fixjson" },
			jsonc = { "fixjson" },
			toml = { "taplo" },
			yaml = { "yamlfmt" },
			terraform = { "terraform_fmt" },
		},
		formatters = {
			csharpier = {
				command = "dotnet-csharpier",
				args = { "--write-stdout" },
			},
		},
	},
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format()
			end,
			desc = "[C]ode [F]ormat",
		},
	},
}
