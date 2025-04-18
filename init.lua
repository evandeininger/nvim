if vim.g.vscode then
  -- Enable clipboard sharing in VSCode
  vim.opt.clipboard = 'unnamedplus'
  return
end

require 'opts'
require 'cmds'
require 'keymaps'
require 'autocmds'
require 'env'

-- [[ Configure and install plugins ]]
require('lazy').setup({
  -- Import all plugins from lua/plugins/
  { import = 'plugins' },
  -- Import plugins from kickstart
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.autopairs',
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤',
    },
  },
})
