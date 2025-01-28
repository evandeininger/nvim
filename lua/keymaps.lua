-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- diagnostics
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- git
vim.keymap.set('n', '<leader>gb', ':G blame<CR>', { noremap = true, silent = true, desc = 'Git blame' })

-- keep value after pasting over
vim.keymap.set('x', '<leader>p', [["_dP]])

-----------------------------------------------------------
-- Copy and Move lines
-- Mappings to move lines, reusing opts var from above
-- NOTE: make sure your terminal is using the left option key as meta (iTerm2, Warp, macOS Terminal)
-----------------------------------------------------------
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- MOVE LINES
-- Normal mode mappings
map('n', '<M-j>', ':m .+1<CR>==', opts)
map('n', '<M-k>', ':m .-2<CR>==', opts)

-- Insert mode mappings
map('i', '<M-j>', '<Esc>:m .+1<CR>==gi', opts)
map('i', '<M-k>', '<Esc>:m .-2<CR>==gi', opts)

-- Visual mode mappings
map('v', '<M-j>', ":m '>+1<CR>gv=gv", opts)
map('v', '<M-k>', ":m '<-2<CR>gv=gv", opts)

-- CLONE LINES
-- Copy line or selection in Normal mode when using Shift with <M-j> and <M-k>
map('n', '<M-J>', 'yyp', opts)
map('n', '<M-K>', 'yyP', opts)

-- Copy line in Insert mode when using Shift with <M-j> and <M-k>
map('i', '<M-J>', '<Esc>yypgi', opts)
map('i', '<M-K>', '<Esc>yyPgi', opts)

-- Copy selection in Visual mode when using Shift with <M-j> and <M-k>
map('v', '<M-J>', 'y`>p`<', opts)
map('v', '<M-K>', 'y`<P`>', opts)

-- [[ Custom Commands ]]
vim.keymap.set('n', '<leader>q', QuitAllButCurrent, { noremap = true, silent = true, desc = 'Quit all except current' })
vim.keymap.set('n', 'gr', Lsp_references_excluding_imports_and_tests, { noremap = true, silent = true, desc = '[G]oto [R]eferences without tests' })

-- [[ Code Folding ]]
-- don't know if I need this with zR and zM
vim.keymap.set('n', '<leader>zs', Close_all_folds, { desc = '[s]hut all folds' })
vim.keymap.set('n', '<leader>zo', Open_all_folds, { desc = '[o]pen all folds' })
-- navigate folds with zj and zk
-- zR open all folds
-- zM close all open folds
-- za toggles the fold at the cursor
-- zO open all folds at the cursor
