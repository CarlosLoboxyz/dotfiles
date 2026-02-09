return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			log_level = vim.log.levels.DEBUG,

			formatters = {
				prettier_svelte = {
					command = "prettier",
					args = { "--plugin", "@prettierSvelte@", "--stdin-filepath", "$FILENAME" },
					env = {
						NODE_PATH = "@nodePath@",
					},
				},
			},

			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				go = { "goimports" },
				nix = { "nixfmt" },

				javascript = { "prettierd" },
				typescript = { "prettierd" },
				html = { "prettierd" },
				css = { "prettierd" },
				json = { "prettierd" },
				vue = { "prettierd" },
				svelte = { "prettier_svelte" },
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
