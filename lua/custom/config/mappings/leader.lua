vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gs', ':Telescope git_status<CR>', { noremap = true, silent = true, desc = 'Git status' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

vim.keymap.set('n', '<leader>gl', ':G blame_line<CR>', { noremap = true, silent = true, desc = 'Git blame line' })
vim.keymap.set('n', '<leader>gb', ':G blame<CR>', { noremap = true, silent = true, desc = 'Git blame' })

vim.keymap.set('n', '<leader>gd', function()
  if next(require('diffview.lib').views) == nil then
    vim.cmd 'DiffviewOpen'
  else
    vim.cmd 'DiffviewClose'
  end
end, { noremap = true, silent = true, desc = 'Toggle Diffview' })

-- Quit all buffers except the current one and nvim-tree
vim.keymap.set('n', '<leader>q', function()
  -- Get the handle of the current buffer
  local current_buffer = vim.api.nvim_get_current_buf()

  -- Get a list of all open buffers
  local buffers = vim.api.nvim_list_bufs()

  -- Loop through all buffer handles
  for _, buf in ipairs(buffers) do
    -- Check if the buffer is listed, is not the NvimTree buffer, and is not the current buffer
    if vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buffer and not string.find(vim.api.nvim_buf_get_name(buf), 'NvimTree') then
      -- Delete the buffer if conditions are met
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { noremap = true, silent = true, desc = 'Quit all except current' })

-- override kickstart
-- vim.o.hlsearch = false
-- vim.wo.relativenumber = true
vim.o.scrolloff = 20
