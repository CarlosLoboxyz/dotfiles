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

require("config.keybindings")
require("plugins.gruvbox")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.telescope")
require("plugins.gitsigns")
require("plugins.neotree")
require("plugins.snacks")
require("plugins.minipairs")
require("plugins.minisnippets")
require("plugins.undotree")
require("plugins.icons")
require("plugins.trouble-nvim")
require("plugins.dropbar")
require("plugins.commentstring")

local servers = {
	"jedi_language_server",
	"gopls",
	"ts_ls",
	"html",
	"cssls",
	"vue_ls",
	"tailwindcss",
	"emmet_language_server",
	"svelte",
}

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end

local cmp = require("cmp")
cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
	},
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
})
