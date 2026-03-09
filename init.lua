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

  -- [[ Configure and install plugins ]]
  local ok, lazy = pcall(require, 'lazy')
  if not ok then
    vim.notify('Failed to load lazy.nvim', vim.log.levels.ERROR)
    return
  end

  lazy.setup({
    -- Import all plugins from lua/plugins/
    { import = 'plugins' },
    -- Import plugins from kickstart
    require 'kickstart.plugins.debug',
  }, {
    install = {
      missing = true,
      colorscheme = { 'nightfox' }, -- fallback colorscheme
    },
    ui = {
      wrap = true, -- wrap lines in UI
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
