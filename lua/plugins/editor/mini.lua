return {
  'echasnovski/mini.nvim',
  version = '*', -- stable version
  config = function()
    require('mini.ai').setup { n_lines = 500 }
    require('mini.surround').setup {
      autowrite = true,
    }
  end,
}
