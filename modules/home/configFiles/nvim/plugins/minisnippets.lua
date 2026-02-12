local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
	snippets = {
		-- Load custom file with global snippets first
		gen_loader.from_file(vim.fn.expand("~/.config/nvim/snippets/global.json")),

		-- Load snippets based on current language
		gen_loader.from_lang(),
	},
})
