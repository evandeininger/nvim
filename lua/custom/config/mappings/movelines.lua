-- Mappings to move lines, reusing opts var from above
-- NOTE: make sure your terminal is using the left option key as meta (iTerm2, Warp, macOS Terminal)
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
map('v', '<M-j>', ':m \'>+1<CR>gv=gv', opts)
map('v', '<M-k>', ':m \'<-2<CR>gv=gv', opts)

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

