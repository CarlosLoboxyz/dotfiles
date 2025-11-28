vim.opt.number = true
vim.opt.wrap = false
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.scrolloff = 5
vim.opt.laststatus = 0
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 300

vim.g.mapleader = " "

require("lazy").setup({
	checker = { enabled = true, notify = false }, 
	spec = {
		{ import = "plugins" },
	},
	performance = {
		reset_packpath = false,
		rtp = {
			reset = false,
		}
	},
	dev = {
		path = "@packPath@/pack/myNeovimPackages/start",
		patterns = {""},
	},
	install = {
		missing = false,
	},
})

require("config.keybindings")

local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
	"force", 
	lspconfig_defaults.capabilities, 
	require("cmp_nvim_lsp").default_capabilities()
)

-- Load language servers
vim.lsp.enable('jedi_language_server')
vim.lsp.enable('gopls')
vim.lsp.enable('ts_ls')

local cmp = require("cmp")
cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
})

