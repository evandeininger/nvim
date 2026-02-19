return {
  'sindrets/diffview.nvim',
  -- event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    vim.keymap.set('n', '<leader>gd', function()
      if next(require('diffview.lib').views) == nil then
        vim.cmd 'DiffviewOpen'
      else
        vim.cmd 'DiffviewClose'
      end
    end, { noremap = true, silent = true, desc = 'Toggle Diffview' })
  end,
}
