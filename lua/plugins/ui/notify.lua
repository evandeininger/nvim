return {
  'rcarriga/nvim-notify',
  config = function()
    require('notify').setup {
      level = 2,
      render = 'compact',
    }
    vim.notify = require 'notify'
  end,
} 