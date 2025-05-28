local keymap_set = require('utils').keymap_set

return {
  'fnune/recall.nvim',
  version = '*',
  config = function()
    local recall = require 'recall'
    local recallSnacks = require 'recall.snacks'

    recall.setup {
      sign = '',
      sign_highlight = '',
    }

    keymap_set('n', '<leader>mm', recall.toggle, 'Toggle mark')
    keymap_set('n', '<leader>mn', recall.goto_next, 'Go to next mark')
    keymap_set('n', '<leader>mp', recall.goto_prev, 'Go to previous mark')
    keymap_set('n', '<leader>mc', recall.clear, 'Clear marks')
    keymap_set('n', '<leader>ml', recallSnacks.pick, 'List marks')
  end,
}
