require("trouble").setup({
	use_diagnostic_signs = true
})

vim.diagnostic.config({
	virtual_text = {
		prefix = '●',
		spacing = 2,
		severity = { min = vim.diagnostic.severity.ERROR }
	},
	signs = true,
	underline = true,
	update_in_insert = false,
})

vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})
