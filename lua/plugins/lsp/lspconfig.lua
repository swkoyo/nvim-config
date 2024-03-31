return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "folke/neodev.nvim", opts = {} },
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
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

		for name, icon in pairs(require("core.constants").icons.diagnostics) do
			name = "DiagnosticSign" .. name
			vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
		end

		local diagnostics = {
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
		}

		vim.diagnostic.config(vim.deepcopy(diagnostics))

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities({}))

		local servers = {
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
			tsserver = {},
		}

		require("mason").setup({
			ui = {
				border = "rounded",
			},
		})

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

		vim.lsp.handlers["textDocument/signatureHelp"] =
			vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua",
			"rust_analyzer",
		})

		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
