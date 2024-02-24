return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	keys = {
		{
			"<leader>fh",
			function()
				local harpoon = require("harpoon")

				local conf = require("telescope.config").values
				local function toggle_telescope(harpoon_files)
					local file_paths = {}
					for _, item in ipairs(harpoon_files.items) do
						table.insert(file_paths, item.value)
					end

					require("telescope.pickers")
						.new({}, {
							prompt_title = "Harpoon",
							finder = require("telescope.finders").new_table({
								results = file_paths,
							}),
							previewer = conf.file_previewer({}),
							sorter = conf.generic_sorter({}),
						})
						:find()
				end
				toggle_telescope(harpoon:list())
			end,
			desc = "Harpoon menu",
		},
		{
			"<leader>ha",
			function()
				require("harpoon"):list():append()
			end,
			desc = "Harpoon add",
		},
		{
			"<leader>h1",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "Harpoon file 1",
		},
		{
			"<leader>h2",
			function()
				require("harpoon.ui"):list():select(2)
			end,
			desc = "Harpoon file 2",
		},
		{
			"<leader>h3",
			function()
				require("harpoon.ui"):list():select(3)
			end,
			desc = "Harpoon file 3",
		},
		{
			"<leader>h4",
			function()
				require("harpoon.ui"):list():select(4)
			end,
			desc = "Harpoon file 4",
		},
	},
	config = true
}
