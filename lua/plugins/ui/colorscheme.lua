return {
	-- {
	-- 	"catppuccin/nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {
	-- 		flavor = "mocha",
	-- 		transparent_background = true,
	-- 		float = {
	-- 			transparent = true,
	-- 			solid = false,
	-- 		},
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("catppuccin").setup(opts)
	-- 		vim.cmd.colorscheme("catppuccin")
	-- 	end,
	-- },
	-- {
	-- 	"neanias/everforest-nvim",
	-- 	version = false,
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {
	-- 		background = "hard",
	-- 		transparent_background_level = 2
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("everforest").setup(opts)
	--            vim.cmd.colorscheme("everforest")
	-- 	end,
	-- },
	-- {
	-- 	"rebelot/kanagawa.nvim",
	-- 	priority = 1000,
	-- 	lazy = false,
	-- 	opts = {
	-- 		theme = "wave",
	-- 		transparent = true,
	-- 		colors = {
	-- 			theme = {
	-- 				all = {
	-- 					ui = {
	-- 						bg_gutter = "none",
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 		overrides = function(colors)
	-- 			return {
	-- 				-- base
	-- 				Normal = { bg = "none" },
	-- 				NormalFloat = { bg = "none" },
	-- 				NormalNC = { bg = "none" },
	-- 				FloatBorder = { bg = "none" },
	-- 				FloatTitle = { bg = "none" },
	--
	-- 				-- gutter
	-- 				SignColumn = { bg = "none" },
	-- 				LineNr = { bg = "none" },
	-- 				CursorLineNr = { bg = "none" },
	-- 				EndOfBuffer = { bg = "none" },
	--
	-- 				CursorLine = { bg = "none" },
	-- 				CursorColumn = { bg = "none" },
	--
	-- 				-- popups / menus
	-- 				Pmenu = { bg = "none" },
	-- 				PmenuSel = { bg = "none" },
	-- 				PmenuSbar = { bg = "none" },
	-- 				PmenuThumb = { bg = "none" },
	--
	-- 				-- telescope (if you use it)
	-- 				TelescopeNormal = { bg = "none" },
	-- 				TelescopeBorder = { bg = "none" },
	-- 				TelescopePromptNormal = { bg = "none" },
	-- 				TelescopePromptBorder = { bg = "none" },
	-- 				TelescopeResultsNormal = { bg = "none" },
	-- 				TelescopeResultsBorder = { bg = "none" },
	-- 				TelescopePreviewNormal = { bg = "none" },
	-- 				TelescopePreviewBorder = { bg = "none" },
	--
	-- 				-- lazy.nvim popup
	-- 				LazyNormal = { bg = "none" },
	--
	-- 				-- mason
	-- 				MasonNormal = { bg = "none" },
	--
	-- 				-- LSP
	-- 				LspInfoBorder = { bg = "none" },
	--
	-- 				-- which-key (if you use it)
	-- 				WhichKeyFloat = { bg = "none" },
	-- 				WhichKeyNormal = { bg = "none" },
	-- 			}
	-- 		end,
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("kanagawa").setup(opts)
	-- 		vim.cmd.colorscheme("kanagawa")
	-- 	end,
	-- },
	-- {
	-- 	"ellisonleao/gruvbox.nvim",
	-- 	priority = 1000,
	-- 	lazy = false,
	-- 	opts = {
	-- 		transparent_mode = true,
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("gruvbox").setup(opts)
	-- 		vim.cmd.colorscheme("gruvbox")
	-- 	end,
	-- },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
