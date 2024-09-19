return {
	"zbirenbaum/copilot.lua",
	enabled = false,
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "InsertEnter",
	opts = {
		suggestion = {
			enabled = false,
		},
		panel = { enabled = false },
	},
}
