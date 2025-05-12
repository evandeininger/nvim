local keymap_set = require('utils').keymap_set

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
keymap_set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
keymap_set('n', '<leader>Q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

-- navigate windows
-- See `:help wincmd` for a list of all window commands
keymap_set('n', '<C-h>', '<C-w><C-h>', 'Move focus to the left window')
keymap_set('n', '<C-l>', '<C-w><C-l>', 'Move focus to the right window')
keymap_set('n', '<C-j>', '<C-w><C-j>', 'Move focus to the lower window')
keymap_set('n', '<C-k>', '<C-w><C-k>', 'Move focus to the upper window')

-- diagnostics
keymap_set('n', '<leader>e', vim.diagnostic.open_float, 'Open floating diagnostic message')

-- git
keymap_set('n', '<leader>gb', ':G blame<CR>', 'Git blame')

-- keep value after pasting over
keymap_set('x', '<leader>p', [["_dP]])

-----------------------------------------------------------
-- Copy and Move lines
-- Mappings to move lines, reusing opts var from above
-- NOTE: make sure your terminal is using the left option key as meta (iTerm2, Warp, macOS Terminal)
-----------------------------------------------------------
-- MOVE LINES
-- Normal mode mappings
keymap_set('n', '<M-j>', ':m .+1<CR>==')
keymap_set('n', '<M-k>', ':m .-2<CR>==')

-- Insert mode mappings
keymap_set('i', '<M-j>', '<Esc>:m .+1<CR>==gi')
keymap_set('i', '<M-k>', '<Esc>:m .-2<CR>==gi')

-- Visual mode mappings
keymap_set('v', '<M-j>', ":m '>+1<CR>gv=gv")
keymap_set('v', '<M-k>', ":m '<-2<CR>gv=gv")

-- CLONE LINES
-- Copy line or selection in Normal mode when using Shift with <M-j> and <M-k>
keymap_set('n', '<M-J>', 'yyp')
keymap_set('n', '<M-K>', 'yyP')

-- Copy line in Insert mode when using Shift with <M-j> and <M-k>
keymap_set('i', '<M-J>', '<Esc>yypgi')
keymap_set('i', '<M-K>', '<Esc>yyPgi')

-- Copy selection in Visual mode when using Shift with <M-j> and <M-k>
keymap_set('v', '<M-J>', 'y`>p`<')
keymap_set('v', '<M-K>', 'y`<P`>')

-----------------------------------------------------------

-- [[ Custom Commands ]]
keymap_set('n', '<leader>q', QuitAllButCurrent, 'Quit all except current')
-- keymap_set('n', 'gr', Lsp_references_excluding_imports_and_tests, '[G]oto [R]eferences without tests')

-- [[ Code Folding ]]
-- don't know if I need this with zR and zM
keymap_set('n', '<leader>zs', Close_all_folds, '[s]hut all folds')
keymap_set('n', '<leader>zo', Open_all_folds, '[o]pen all folds')
-- navigate folds with zj and zk
-- zR open all folds
-- zM close all open folds
-- za toggles the fold at the cursor
-- zO open all folds at the cursor

-- Map Ctrl + Left Mouse
keymap_set('n', '<C-LeftMouse>', '<Plug>(VM-Mouse-Cursor)')
-- Map Ctrl + Right Mouse
keymap_set('n', '<C-RightMouse>', '<Plug>(VM-Mouse-Word)')
-- Map Alt + Ctrl + Right Mouse
keymap_set('n', '<M-C-RightMouse>', '<Plug>(VM-Mouse-Column)')
