return {
	"echasnovski/mini.indentscope",
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		symbol = "▏",
		options = { try_as_border = true },
	},
}
