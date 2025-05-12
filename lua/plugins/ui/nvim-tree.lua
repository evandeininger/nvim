return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      filters = {
        custom = { 'node_modules/.*' },
      },
      open_on_tab = false,
      hijack_cursor = true,
      diagnostics = {
        enable = true,
        icons = {
          hint = '',
          info = '',
          warning = '',
          error = '',
        },
      },
      update_focused_file = {
        enable = true,
      },
      renderer = {
        highlight_opened_files = 'all',
      },
      view = {
        side = 'left',
        width = 40,
      },
      git = {
        ignore = false,
        enable = true,
      },
      system_open = {
        cmd = nil,
        args = {},
      },
    }
    vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
  end,
}

