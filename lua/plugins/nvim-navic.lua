return {
	"SmiteshP/nvim-navic",
	lazy = true,
	opts = function()
		return {
			separator = " > ",
			highlight = true,
			depth_limit = 5,
			icons = require("config.utils").icons.kinds,
		}
	end,
}
