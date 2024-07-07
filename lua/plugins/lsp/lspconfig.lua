return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "folke/neodev.nvim", opts = {} },
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- { "j-hui/fidget.nvim", opts = {} },
	},
	opts = {
		diagnostics = {
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			virtual_text = {
				spacing = 4,
				source = "if_many",
				prefix = "●",
			},
			float = {
				border = "rounded",
			},
		},
		servers = {
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			},
			rust_analyzer = {},
			gopls = {},
			tsserver = {
				on_attach = function(_, bufnr)
					vim.keymap.set("n", "<leader>co", function()
						vim.lsp.buf.code_action({
							apply = true,
							context = {
								only = { "source.organizeImports.ts" },
								diagnostics = {},
							},
						})
					end, { buffer = bufnr, desc = "LSP: [C]ode [O]rganize Imports (TS)" })
					vim.keymap.set("n", "<leader>cr", function()
						vim.lsp.buf.code_action({
							apply = true,
							context = {
								only = { "source.removeUnused.ts" },
								diagnostics = {},
							},
						})
					end, { buffer = bufnr, desc = "LSP: [C]ode [R]emove Unused Imports (TS)" })
				end,
				settings = {
					completions = {
						completeFunctionCalls = true,
					},
				},
			},
			eslint = {
				on_attach = function(client, _)
					client.server_capabilities.hoverProvider = false
				end,
			},
			solargraph = {},
			pyright = {
				disableOrganizeImports = true,
				-- settings = {
				-- 	python = {
				-- 		analysis = {
				-- 			typeCheckingMode = "off",
				-- 		},
				-- 	},
				-- },
			},
			ruff_lsp = {
				on_attach = function(client, bufnr)
					client.server_capabilities.hoverProvider = false
					vim.keymap.set("n", "<leader>co", function()
						vim.lsp.buf.code_action({
							apply = true,
							context = {
								only = { "source.organizeImports" },
								diagnostics = {},
							},
						})
					end, { buffer = bufnr, desc = "LSP: [C]ode [O]rganize Imports (Ruff)" })
				end,
				init_options = {
					settings = {
						args = {},
					},
				},
			},
			dockerls = {},
			docker_compose_language_service = {},
			clangd = {
				capabilities = {
					offsetEncoding = { "utf-16" },
				},
			},
			astro = {
				init_options = {
					typescript = {
						tsdk = "node_modules/typescript/lib",
					},
				},
			},
			bashls = {},
			omnisharp = {
				handlers = {
					["textDocument/definition"] = function(...)
						return require("omnisharp_extended").handler(...)
					end,
				},
				on_attach = function(_, bufnr)
					vim.keymap.set("n", "gd", function()
						require("omnisharp_extended").telescope_lsp_definitions()
					end, { buffer = bufnr, desc = "[G]oto [D]efinition" })
				end,
				enable_roslyn_analyzers = true,
				organize_imports_on_format = true,
				enable_import_completion = true,
			},
		},
	},
	config = function(_, opts)
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map("<leader>cd", vim.diagnostic.open_float, "[C]ode [D]iagnostics")
				map("]d", function()
					vim.diagnostic.goto_next({ severity = nil })
				end, "Next [D]iagnostic")
				map("[d", function()
					vim.diagnostic.goto_prev({ severity = nil })
				end, "Previous [D]iagnostic")
				map("]e", function()
					vim.diagnostic.goto_next({ severity = vim.diagnostic.severity["ERROR"] })
				end, "Next [E]rror")
				map("[e", function()
					vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity["ERROR"] })
				end, "Previous [E]rror")
				map("]w", function()
					vim.diagnostic.goto_next({ severity = vim.diagnostic.severity["WARN"] })
				end, "Next [W]arning")
				map("[w", function()
					vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity["WARN"] })
				end, "Previous [W]arning")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})

		require("lspconfig.ui.windows").default_options.border = "rounded"

		for name, icon in pairs(require("core.constants").icons.diagnostics) do
			name = "DiagnosticSign" .. name
			vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
		end

		vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities({}))

		require("mason").setup({
			ui = {
				border = "rounded",
			},
		})

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

		vim.lsp.handlers["textDocument/signatureHelp"] =
			vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

		local ensure_installed = vim.tbl_keys(opts.servers or {})
		vim.list_extend(ensure_installed, {
			"stylua",
			"rust_analyzer",
			"tsserver",
			"pyright",
			"ruff_lsp",
			"gopls",
			"clangd",
			"bashls",
			"hadolint",
			"dockerls",
			"docker_compose_language_service",
		})

		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = opts.servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		-- Cuda
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "cuda",
			callback = function()
				vim.bo.commentstring = "// %s"
			end,
		})
	end,
}
