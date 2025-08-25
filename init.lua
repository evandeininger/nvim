if vim.g.vscode then
  -- Enable clipboard sharing in VSCode
  vim.opt.clipboard = 'unnamedplus'
  -- Ensure clipboard is set immediately in VSCode
  vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
  end)
  return
else
  require 'opts'
  require 'cmds'
  require 'keymaps'
  require 'autocmds'
  require 'env'
  require 'defer'

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
end
