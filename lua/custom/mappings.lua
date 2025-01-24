-----------------------------------------------------------
-- git signs
-----------------------------------------------------------
vim.keymap.set('n', '<leader>nh', ':Gitsigns next_hunk<CR>', { noremap = true, silent = true, desc = 'Next hunk [Gitsigns]' })
vim.keymap.set('n', '<leader>Nh', ':Gitsigns prev_hunk<CR>', { noremap = true, silent = true, desc = 'Prev hunk [Gitsigns]' })

-----------------------------------------------------------
-- update goto references to exclude imports and tests
-----------------------------------------------------------
_G.lsp_references_excluding_imports_and_tests = function()
  local entry_filter = function(entry)
    -- Example: Exclude entries that contain 'import' in a .ts file
    return not (entry.filename:match '%.ts$' and entry.text:match 'import')
  end

  require('telescope.builtin').lsp_references {
    -- Exclude test files
    file_ignore_patterns = { '%.test%.ts' },
    entry_maker = function(entry)
      if entry_filter(entry) then
        return require('telescope.make_entry').gen_from_quickfix()(entry)
      end
    end,
  }
end

vim.api.nvim_set_keymap(
  'n',
  'gr',
  '<cmd>lua lsp_references_excluding_imports_and_tests()<CR>',
  { noremap = true, silent = true, desc = '[G]oto [R]eferences without tests' }
)

-----------------------------------------------------------
-- custom mappings
-----------------------------------------------------------
-- lazygit
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { noremap = true, silent = true })

-- nvim-tree
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- telescope
vim.keymap.set('n', '<leader>gs', ':Telescope git_status<CR>', { noremap = true, silent = true, desc = 'Git status' })

-- diagnostics
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- git
vim.keymap.set('n', '<leader>gl', ':G blame_line<CR>', { noremap = true, silent = true, desc = 'Git blame line' })
vim.keymap.set('n', '<leader>gb', ':G blame<CR>', { noremap = true, silent = true, desc = 'Git blame' })

-- diffview toggle
vim.keymap.set('n', '<leader>gd', function()
  if next(require('diffview.lib').views) == nil then
    vim.cmd 'DiffviewOpen'
  else
    vim.cmd 'DiffviewClose'
  end
end, { noremap = true, silent = true, desc = 'Toggle Diffview' })

-- override kickstart
-- vim.o.hlsearch = false
-- vim.wo.relativenumber = true
vim.o.scrolloff = 50

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

-----------------------------------------------------------
-- AUTO SAVING
-- autosave all the time
-----------------------------------------------------------
-- vim.cmd([[ au TextChanged,InsertLeave * :w ]])
--
-- -- save on focus out
-- vim.cmd([[ au FocusLost * :w ]])

-----------------------------------------------------------
--- CODE FOLDING
-----------------------------------------------------------
vim.opt.foldcolumn = '0'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldtext = ''

vim.opt.foldnestmax = 3
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

local function close_all_folds()
  vim.api.nvim_exec2('%foldc!', { output = false })
end
local function open_all_folds()
  vim.api.nvim_exec2('%foldo!', { output = false })
end

-- don't know if I need this with zR and zM
vim.keymap.set('n', '<leader>zs', close_all_folds, { desc = '[s]hut all folds' })
vim.keymap.set('n', '<leader>zo', open_all_folds, { desc = '[o]pen all folds' })

-- zR open all folds
-- zM close all open folds
-- za toggles the fold at the cursor
-- zO open all folds at the cursor
--
-- navigate folds with zj and zk
