return {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
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

    -- <leader>tc toggles context
    vim.keymap.set('n', '<leader>tc', function()
      require('treesitter-context').toggle()
    end, { desc = 'Toggle treesitter context' })
  end,
}

