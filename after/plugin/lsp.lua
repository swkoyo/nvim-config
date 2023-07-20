local lsp = require("lsp-zero").preset({})

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr, preserve_mappings = false })
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = true })
	vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { buffer = true })
end)

lsp.format_mapping("<leader>f", {
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		["rust_analyzer"] = { "rust" },
		["dockerls"] = { "dockerfile" },
		["null-ls"] = { "lua", "python", "typescript", "typescriptreact", "javascript", "go", "sh" },
	},
})

lsp.set_sign_icons({
	error = "",
	warn = "",
	hint = "",
	info = "",
})

lsp.extend_cmp()

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
		["<C-f>"] = cmp_action.luasnip_jump_forward(),
		["<C-b>"] = cmp_action.luasnip_jump_backward(),
	},
})

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"tsserver",
		"rust_analyzer",
		"lua_ls",
		"pyright",
		"gopls",
		"bashls",
		"dockerls",
	},
	handlers = {
		lsp.default_setup,
	},
})
