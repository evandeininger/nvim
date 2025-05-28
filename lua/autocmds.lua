-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- AUTO SAVING
-- autosave all the time
-----------------------------------------------------------
-- vim.cmd([[ au TextChanged,InsertLeave * :w ]])
--
-- -- save on focus out
-- vim.cmd([[ au FocusLost * :w ]])

-------------
-- TESTING --
-------------
-- Disable swapfile for NvimTree buffers
vim.api.nvim_create_autocmd('BufReadPre', {
  pattern = 'NvimTree_*',
  callback = function()
    vim.opt_local.swapfile = false
  end,
})

-------------
-- TESTING --
-------------
-- Auto-cleanup stale swap files at startup
-- vim.api.nvim_create_autocmd('VimEnter', {
--   callback = function()
--     local swap_dir = vim.fn.stdpath 'state' .. '/nvim/swap'
--     local handle = io.popen('find "' .. swap_dir .. '" -type f -name "*.swp"')
--     if handle then
--       for file in handle:lines() do
--         os.remove(file)
--         vim.notify('Deleted stale swap file: ' .. file, vim.log.levels.WARN)
--       end
--       handle:close()
--     end
--   end,
-- })
