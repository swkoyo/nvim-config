return {
	{ "VonHeikemen/lsp-zero.nvim", branch = "dev-v3", lazy = true, config = false },
	{ "williamboman/mason.nvim", cmd = { "Mason", "MasonInstall", "MasonUpdate" }, lazy = true, config = true },
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
		},
		config = function()
			require("lsp-zero").extend_cmp()

			local cmp = require("cmp")
			local cmp_action = require("lsp-zero").cmp_action()

			cmp.setup({
				mapping = {
					["<Tab>"] = nil,
					["<S-Tab>"] = nil,
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_action),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_action),
					-- ["<C-f>"] = cmp_action.luasnip_jump_forward(),
					-- ["<C-b>"] = cmp_action.luasnip_jump_backward(),
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "hrsh7th/cmp-nvim-lsp" },
		},
		config = function()
			local lsp = require("lsp-zero").preset({})
			local icons = require("config.utils").icons.diagnostics

			lsp.on_attach(function(client, bufnr)
				lsp.default_keymaps({ buffer = bufnr, preserve_mappings = false })

				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, bufnr)
				end

				local opts = { buffer = bufnr }

				vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { buffer = true })
				vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
				vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
				vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
				vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = true })
				vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
				vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
				vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)

				vim.keymap.set("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
				vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
				vim.keymap.set("n", "<leader>cd", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
				vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", opts)
			end)

			lsp.format_mapping("<leader>cf", {
				format_opts = {
					async = false,
					timeout_ms = 10000,
				},
				servers = {
					["null-ls"] = {
						"lua",
						"python",
						"typescript",
						"typescriptreact",
						"javascript",
						"go",
						"sh",
						"json",
						"jsonc",
						"c",
						"cpp",
						"yaml",
					},
					["rust_analyzer"] = {
						"rust",
					},
					["dockerls"] = {
						"dockerfile",
					},
				},
			})

			lsp.set_sign_icons({
				error = icons.Error,
				warn = icons.Warn,
				hint = icons.Hint,
				info = icons.Info,
			})

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls" },
				handlers = {
					lsp.default_setup,
				},
			})
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			local nls = require("null-ls")
			return {
				sources = {
					-- Lua
					nls.builtins.formatting.stylua,

					-- TS/JS
					nls.builtins.code_actions.eslint_d,
					nls.builtins.diagnostics.eslint_d,
					nls.builtins.formatting.prettierd,

					-- Python
					nls.builtins.formatting.blackd,
					nls.builtins.diagnostics.ruff,

					-- Golang
					nls.builtins.formatting.goimports,

					-- Bash
					nls.builtins.formatting.shfmt,

					-- JSON
					nls.builtins.formatting.fixjson,

					-- YAML
					nls.builtins.formatting.yamlfmt,

					-- C/C++
					nls.builtins.formatting.clang_format,
				},
			}
		end,
	},
}
