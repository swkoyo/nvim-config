require("toggleterm").setup({
	direction = "float",
})

vim.keymap.set("n", "<leader>pt", ":ToggleTerm<CR>")
vim.keymap.set("t", "<leader>pt", "exit<CR>")
