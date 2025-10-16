return {
  'echasnovski/mini.nvim',
  version = '*', -- stable version
  config = function()
    require('mini.ai').setup { n_lines = 500 }
    require('mini.surround').setup {
      autowrite = true,
    }

    -- Auto-pairing brackets, quotes, etc (replaces nvim-autopairs)
    require('mini.pairs').setup()

    -- Indent scope highlighting (shows current scope)
    require('mini.indentscope').setup {
      symbol = '│',
      options = { try_as_border = true },
      draw = {
        delay = 0,
        animation = require('mini.indentscope').gen_animation.none(),
      },
    }
  end,
}
