return {
	"ThePrimeagen/harpoon",
	-- stylua: ignore
	keys = {
		{ "<leader>hm", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu" },
		{ "<leader>ha", function() require("harpoon.mark").add_file() end, desc = "Harpoon add" },
		{ "<leader>h1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon file 1" },
		{ "<leader>h2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon file 2" },
		{ "<leader>h3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon file 3" },
		{ "<leader>h4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon file 4" },
	},
	config = true,
}
