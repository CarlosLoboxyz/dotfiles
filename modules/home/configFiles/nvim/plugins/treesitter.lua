local configs = require("nvim-treesitter.configs")

configs.setup({
    ensure_installed = {}, -- Nix handles grammars, leave this empty
    sync_install = false,
    highlight = {
        enable = true,
        disable = { "svelte" },
    },
    indent = { enable = true },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
            },
        },
    },
})
