return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	opts = {
		options = {
			globalstatus = true,
			component_separators = { left = "│", right = "│" },
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = {
				{ "branch", icon = "" },
				{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
			},
			lualine_c = {
				{ "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
			},
			lualine_x = {
				{
					"diagnostics",
					sources = { "nvim_lsp" },
					symbols = { error = " ", warn = " ", info = " ", hint = " " },
				},
				{
					function()
						local clients = vim.lsp.get_clients({ bufnr = 0 })
						if #clients == 0 then
							return ""
						end
						local names = {}
						for _, client in ipairs(clients) do
							table.insert(names, client.name)
						end
						return " " .. table.concat(names, ", ")
					end,
				},
			},
			lualine_y = { "filetype" },
			lualine_z = { "location", "progress" },
		},
	},
}
