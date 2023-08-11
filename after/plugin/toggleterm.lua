require("toggleterm").setup({
	direction = "horizontal",
})

vim.keymap.set("n", "<leader>pt", ":ToggleTerm<CR>")
vim.keymap.set("t", "<leader>pt", "exit<CR>")
