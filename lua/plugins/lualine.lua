return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = function()
		local icons = require("config.utils").icons
		local Util = require("util")

		return {
			options = {
				theme = "auto",
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{ "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
					{
						"navic",
						color_correction = "static",
						padding = { left = 1, right = 0 },
					},
				},
				lualine_x = {
					{
						function()
							return require("noice").api.status.command.get()
						end,
						cond = function()
							return package.loaded["noice"] and require("noice").api.status.command.has()
						end,
						color = Util.fg("Statement"),
					},
					{
						function()
							return require("noice").api.status.mode.get()
						end,
						cond = function()
							return package.loaded["noice"] and require("noice").api.status.mode.has()
						end,
						color = Util.fg("Constant"),
					},
					-- {
					-- 	function()
					-- 		return "  " .. require("dap").status()
					-- 	end,
					-- 	cond = function()
					-- 		return package.loaded["dap"] and require("dap").status() ~= ""
					-- 	end,
					-- 	color = Util.fg("Debug"),
					-- },
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = Util.fg("Special"),
					},
					{
						"diff",
						symbols = {
							added = icons.git.added,
							modified = icons.git.modified,
							removed = icons.git.removed,
						},
					},
					{
						function()
							local icon = require("configs.util").icons.kinds.Copilot
							local status = require("copilot.api").status.data
							return icon .. (status.message or "")
						end,
						cond = function()
							local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
							return ok and #clients > 0
						end,
						color = function()
							local Util = require("util")
							local colors = {
								[""] = Util.fg("Special"),
								["Normal"] = Util.fg("Special"),
								["Warning"] = Util.fg("DiagnosticError"),
								["InProgress"] = Util.fg("DiagnosticWarn"),
							}
							if not package.loaded["copilot"] then
								return
							end
							local status = require("copilot.api").status.data
							return colors[status.status] or colors[""]
						end,
					},
				},
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return " " .. os.date("%R")
					end,
				},
			},
			extensions = { "lazy" },
		}
	end,
}
