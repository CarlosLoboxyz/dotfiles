vim.g.mapleader = " "
vim.keymap.set("n", "<leader>;", vim.cmd.Lexplore)
vim.keymap.set("n", "<leader>wj", vim.cmd.split)
vim.keymap.set("n", "<leader>wl", vim.cmd.vsplit)
vim.keymap.set("n", "<leader><Tab>", vim.cmd.tabnext)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

