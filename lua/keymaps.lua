local keymap_set = require('utils').keymap_set

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
keymap_set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
keymap_set('n', '<leader>Q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

-- Navigate diagnostics
keymap_set('n', ']e', function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, 'Jump to next error')
keymap_set('n', '[e', function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, 'Jump to previous error')
keymap_set('n', ']w', function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, 'Jump to next warning')
keymap_set('n', '[w', function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
end, 'Jump to previous warning')

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
keymap_set('n', '<M-j>', ':m .+1<CR>==', 'Move line down in Normal mode')
keymap_set('n', '<M-k>', ':m .-2<CR>==', 'Move line up in Normal mode')

-- Insert mode mappings
keymap_set('i', '<M-j>', '<Esc>:m .+1<CR>==gi', 'Move line down in Insert mode')
keymap_set('i', '<M-k>', '<Esc>:m .-2<CR>==gi', 'Move line up in Insert mode')

-- Visual mode mappings
keymap_set('v', '<M-j>', ":m '>+1<CR>gv=gv", 'Move selection down in Visual mode')
keymap_set('v', '<M-k>', ":m '<-2<CR>gv=gv", 'Move selection up in Visual mode')

-- CLONE LINES
-- Copy line or selection in Normal mode when using Shift with <M-j> and <M-k>
keymap_set('n', '<M-J>', 'yyp', 'Copy line down in Normal mode')
keymap_set('n', '<M-K>', 'yyP', 'Copy line up in Normal mode')

-- Copy line in Insert mode when using Shift with <M-j> and <M-k>
keymap_set('i', '<M-J>', '<Esc>yypgi', 'Copy line down in Insert mode')
keymap_set('i', '<M-K>', '<Esc>yyPgi', 'Copy line up in Insert mode')

-- Copy selection in Visual mode when using Shift with <M-j> and <M-k>
keymap_set('v', '<M-J>', 'y`>p`<', 'Copy selection down in Visual mode')
keymap_set('v', '<M-K>', 'y`<P`>', 'Copy selection up in Visual mode')

-----------------------------------------------------------

-- [[ Custom Commands ]]
keymap_set('n', '<leader>q', QuitAllButCurrent, 'Quit all except current')

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

keymap_set('n', 'C-O', ':b#', 'Previous Buffer')

-----------------------------------------------------------
--- Copy file paths
--- <leader>yd: copy file path relative to current working directory
-----------------------------------------------------------
vim.keymap.set('n', '<leader>yf', function()
  local filepath = vim.fn.expand '%:.'
  vim.fn.setreg('+', filepath)
  vim.fn.setreg('*', filepath)
  vim.notify('Copied to clipboard: ' .. filepath, vim.log.levels.INFO)
end, { desc = 'Copy file path relative to CWD', noremap = true, silent = true })

-----------------------------------------------------------
--- Terminal mode
--- Pressing <Esc> in terminal mode to exit to normal mode
-----------------------------------------------------------
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Terminal: exit to Normal mode' })


keymap_set('n', '<leader>fh', ':%DiffviewFileHistory<CR>', '[f]ile [h]istory')
