return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewFocusFiles', 'DiffviewToggleFiles', 'DiffviewRefresh', 'DiffviewLog' },
  keys = {
    {
      '<leader>gd',
      function()
        if next(require('diffview.lib').views) == nil then
          vim.cmd 'DiffviewOpen'
        else
          vim.cmd 'DiffviewClose'
        end
      end,
      desc = 'Toggle Diffview',
    },
  },
}
