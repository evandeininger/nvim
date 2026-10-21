return {
  'nvim-treesitter/nvim-treesitter-context',
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = 'TSContext',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  keys = {
    {
      '<leader>tc',
      function()
        require('treesitter-context').toggle()
      end,
      desc = 'Toggle treesitter context',
    },
  },
  config = function()
    require('treesitter-context').setup {
      enable = true,
      max_lines = 0,
      trim_scope = 'outer',
      mode = 'cursor',
      separator = '—',
      zindex = 20,
      on_attach = nil,
    }
  end,
}

