vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy selected to global clipboard" })
vim.keymap.set("n", "<leader>y", [["+Y]], { desc = "Copy line to global clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d"]], { desc = "Delete line without copying" })

vim.keymap.set("n", "<leader>ft", "<cmd>silent !tmux neww tmux-sessionizer<cr>", { desc = "TMUX Sessionizer" })

vim.keymap.set("n", "<leader>bx", "<cmd>!chmod +x %<cr>", { silent = true, desc = "Make current buffer executable" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Bring line below next to current" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Keep cursor at center during page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Keep cursor at center during page up" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Keep cursor at center during search next" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Keep cursor at center during search prev" })

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set(
	"n",
	"<leader>cr",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor in current buffer" }
)
