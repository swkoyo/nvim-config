return {
	"ThePrimeagen/harpoon",
	-- stylua: ignore
	keys = {
		{ "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end },
		{ "<leader>a", function() require("harpoon.mark").add_file() end, desc = "Harpoon add" },
		{ "<C-1>", function() require("harpoon.ui").nav_file(1) end },
		{ "<C-2>", function() require("harpoon.ui").nav_file(2) end },
		{ "<C-3>", function() require("harpoon.ui").nav_file(3) end },
		{ "<C-4>", function() require("harpoon.ui").nav_file(4) end },
	},
	config = true,
}
