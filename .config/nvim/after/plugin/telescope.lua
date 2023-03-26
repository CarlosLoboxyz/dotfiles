local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function() builtin.find_files() end)
vim.keymap.set('n', '<leader>pb', function() builtin.buffers() end)
vim.keymap.set('n', '<C-p>', function() builtin.git_files() end)
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ")})
end)

require('telescope').setup {
    defaults = {
        file_ignore_patterns = { "node_modules" }
    }
}
