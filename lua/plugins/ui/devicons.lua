return {
  'nvim-tree/nvim-web-devicons',
  config = function()
    require('nvim-web-devicons').setup {
      override = {
        ['.prettierrc'] = {
          icon = '',  -- You can use any nerd font icon here
          color = '#cbcb41',
          name = 'Prettier',
        },
      },
      strict = true,
    }
  end,
} 