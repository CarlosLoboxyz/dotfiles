return {
	"echasnovski/mini.snippets",
	version = false, -- or specify a tag/release if you prefer
	event = "VeryLazy",
	config = function()
		local gen_loader = require("mini.snippets").gen_loader
		require("mini.snippets").setup({
			snippets = {
				-- Load custom file with global snippets first
				gen_loader.from_file(vim.fn.expand("~/.config/nvim/snippets/global.json")),

				-- Load snippets based on current language by reading files from
				-- "snippets/" subdirectories from "runtimepath" directories.
				gen_loader.from_lang(),
			},
		})
	end,
}

