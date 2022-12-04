syntax enable
set background=dark
set termguicolors
colorscheme gruvbox

lua << EOF
require("transparent").setup({
	enable = true,
	extra_groups = {
		"GitGutterAdd",
		"GitGutterChange",
		"GitGutterDelete",
	},
})

local gruvbox = {
    fg = '#928374',
    bg = '#1F2223',
    black ='#1B1B1B',
    skyblue = '#458588',
    cyan = '#83a597',
    green = '#689d6a',
    oceanblue = '#1d2021',
    magenta = '#fb4934',
    orange = '#fabd2f',
    red = '#cc241d',
    violet = '#b16286',
    white = '#ebdbb2',
    yellow = '#d79921',
}
require('feline').setup{
	theme = gruvbox
}

-- empty setup using defaults
require("nvim-tree").setup {
	disable_netrw = true,
	open_on_tab = true,
}
EOF
