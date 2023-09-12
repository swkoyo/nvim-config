return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{
				"hrsh7th/cmp-nvim-lsp",
				cond = function()
					return require("util").has("nvim-cmp")
				end,
			},
		},
		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
				float = {
					border = "rounded",
				},
			},
			inlay_hints = {
				enabled = false,
			},
			capabilities = {},
			autoformat = false,
			format_notify = true,
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			servers = {
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "off",
							},
						},
					},
				},
			},
			setup = {},
		},
		config = function(_, opts)
			local Util = require("util")

			if Util.has("neoconf.nvim") then
				local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
				require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
			end

			require("plugins.lsp.format").setup(opts)

			Util.on_attach(function(client, buffer)
				require("plugins.lsp.keymaps").on_attach(client, buffer)
			end)

			local register_capability = vim.lsp.handlers["client/registerCapability"]

			vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
				local ret = register_capability(err, res, ctx)
				local client_id = ctx.client_id
				---@type lsp.Client
				local client = vim.lsp.get_client_by_id(client_id)
				local buffer = vim.api.nvim_get_current_buf()
				require("plugins.lsp.keymaps").on_attach(client, buffer)
				return ret
			end

			-- diagnostics
			for name, icon in pairs(require("config.utils").icons.diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

			if opts.inlay_hints.enabled and inlay_hint then
				Util.on_attach(function(client, buffer)
					if client.supports_method("textDocument/inlayHint") then
						inlay_hint(buffer, true)
					end
				end)
			end

			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
					or function(diagnostic)
						local icons = require("utils").icons.diagnostics
						for d, icon in pairs(icons) do
							if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
								return icon
							end
						end
					end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available through mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			if have_mason then
				mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
			end

			if Util.lsp_get_config("denols") and Util.lsp_get_config("tsserver") then
				local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
				Util.lsp_disable("tsserver", is_deno)
				Util.lsp_disable("denols", function(root_dir)
					return not is_deno
				end)
			end
		end,
	},

	-- formatters
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			return {
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
				sources = {
					-- Lua
					nls.builtins.formatting.stylua,

					-- TS/JS
					nls.builtins.code_actions.eslint_d,
					nls.builtins.diagnostics.eslint_d,
					nls.builtins.formatting.prettierd,

					-- Python
					nls.builtins.formatting.black,
                    nls.builtins.formatting.isort,
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

	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
			},
			ui = {
				border = "rounded",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
}

-- return {
-- 	{ "VonHeikemen/lsp-zero.nvim", branch = "dev-v3", lazy = true, config = false },
-- 	{ "williamboman/mason.nvim", cmd = { "Mason", "MasonInstall", "MasonUpdate" }, lazy = true, config = true },
-- 	{
-- 		"hrsh7th/nvim-cmp",
-- 		event = "InsertEnter",
-- 		dependencies = {
-- 			{ "L3MON4D3/LuaSnip" },
-- 		},
-- 		config = function()
-- 			require("lsp-zero").extend_cmp()
--
-- 			local cmp = require("cmp")
-- 			local cmp_action = require("lsp-zero").cmp_action()
--
-- 			cmp.setup({
-- 				mapping = {
-- 					["<Tab>"] = nil,
-- 					["<S-Tab>"] = nil,
-- 					["<C-Space>"] = cmp.mapping.complete(),
-- 					["<C-y>"] = cmp.mapping.confirm({ select = true }),
-- 					["<C-e>"] = cmp.mapping.abort(),
-- 					["<C-p>"] = cmp.mapping.select_prev_item(cmp_action),
-- 					["<C-n>"] = cmp.mapping.select_next_item(cmp_action),
-- 					-- ["<C-f>"] = cmp_action.luasnip_jump_forward(),
-- 					-- ["<C-b>"] = cmp_action.luasnip_jump_backward(),
-- 				},
-- 			})
-- 		end,
-- 	},
-- 	{
-- 		"williamboman/mason-lspconfig.nvim",
-- 		cmd = { "LspInfo", "LspInstall", "LspStart" },
-- 		event = { "BufReadPre", "BufNewFile" },
-- 		dependencies = {
-- 			{ "neovim/nvim-lspconfig" },
-- 			{ "hrsh7th/cmp-nvim-lsp" },
-- 		},
-- 		config = function()
-- 			local lsp = require("lsp-zero").preset({})
-- 			local icons = require("config.utils").icons.diagnostics
--
-- 			lsp.on_attach(function(client, bufnr)
-- 				lsp.default_keymaps({ buffer = bufnr, preserve_mappings = false })
--
-- 				if client.server_capabilities.documentSymbolProvider then
-- 					require("nvim-navic").attach(client, bufnr)
-- 				end
--
-- 				local opts = { buffer = bufnr }
--
-- 				vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
-- 				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { buffer = true })
-- 				vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
-- 				vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
-- 				vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
-- 				vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = true })
-- 				vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
-- 				vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
-- 				vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
--
-- 				vim.keymap.set("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
-- 				vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
-- 				vim.keymap.set("n", "<leader>cd", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
-- 				vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", opts)
-- 			end)
--
-- 			lsp.format_mapping("<leader>cf", {
-- 				format_opts = {
-- 					async = false,
-- 					timeout_ms = 10000,
-- 				},
-- 				servers = {
-- 					["null-ls"] = {
-- 						"lua",
-- 						"python",
-- 						"typescript",
-- 						"typescriptreact",
-- 						"javascript",
-- 						"go",
-- 						"sh",
-- 						"json",
-- 						"jsonc",
-- 						"c",
-- 						"cpp",
-- 						"yaml",
-- 					},
-- 					["rust_analyzer"] = {
-- 						"rust",
-- 					},
-- 					["dockerls"] = {
-- 						"dockerfile",
-- 					},
-- 				},
-- 			})
--
-- 			lsp.set_sign_icons({
-- 				error = icons.Error,
-- 				warn = icons.Warn,
-- 				hint = icons.Hint,
-- 				info = icons.Info,
-- 			})
--
-- 			require("mason-lspconfig").setup({
-- 				ensure_installed = { "lua_ls" },
-- 				handlers = {
-- 					lsp.default_setup,
-- 				},
-- 			})
-- 		end,
-- 	},
-- 	{
-- 		"jose-elias-alvarez/null-ls.nvim",
-- 		event = { "BufReadPre", "BufNewFile" },
-- 		opts = function()
-- 			local nls = require("null-ls")
-- 			return {
-- 				sources = {
-- 					-- Lua
-- 					nls.builtins.formatting.stylua,
--
-- 					-- TS/JS
-- 					nls.builtins.code_actions.eslint_d,
-- 					nls.builtins.diagnostics.eslint_d,
-- 					nls.builtins.formatting.prettierd,
--
-- 					-- Python
-- 					nls.builtins.formatting.blackd,
-- 					nls.builtins.diagnostics.ruff,
--
-- 					-- Golang
-- 					nls.builtins.formatting.goimports,
--
-- 					-- Bash
-- 					nls.builtins.formatting.shfmt,
--
-- 					-- JSON
-- 					nls.builtins.formatting.fixjson,
--
-- 					-- YAML
-- 					nls.builtins.formatting.yamlfmt,
--
-- 					-- C/C++
-- 					nls.builtins.formatting.clang_format,
-- 				},
-- 			}
-- 		end,
-- 	},
-- }
