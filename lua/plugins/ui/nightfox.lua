return {
  'EdenEast/nightfox.nvim',
  config = function()
    require('nightfox').setup {
      groups = {
        all = {
          -- Keep the left bar (gutter) unchanged
          SignColumn = { bg = 'bg1' },
          LineNr = { bg = 'bg1' },

          SnacksPickerTree = { fg = 'palette.bg4', bg = 'bg0' }, -- was linking to LineNr

          WinSeparator = { fg = 'palette.bg4', bg = 'bg0' },
          VertSplit = { fg = 'palette.bg4', bg = 'bg0' },

          NormalFloat = { bg = 'bg0' },
          FloatBorder = { fg = 'palette.bg4', bg = 'bg0' },
        },
      },
      palettes = {
        duskfox = {
          -- bg1 = '#1a1922',
          -- bg2 = '#2c2559',
        },
      },
    }
    vim.cmd.colorscheme 'duskfox'
  end,
}
