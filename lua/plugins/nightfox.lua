return {
  'EdenEast/nightfox.nvim',
  config = function()
    require('nightfox').setup {
      palettes = {
        duskfox = {
          bg1 = '#1a1922',
        },
      },
    }
    vim.cmd.colorscheme 'duskfox'
  end,
} 