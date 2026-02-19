return {
  'zaldih/themery.nvim',
  lazy = false,
  config = function()
    require('themery').setup {
      themes = {
        {
          name = 'Rose Pine',
          colorscheme = 'rose-pine',
        },
        {
          name = 'Duskfox',
          colorscheme = 'duskfox',
        },
        {
          name = 'Gruvbox Hard',
          colorscheme = 'gruvbox',
          before = "return function() require('gruvbox').setup({ contrast = 'hard' }) end",
        },
        {
          name = 'Gruvbox Soft',
          colorscheme = 'gruvbox',
          before = "return function() require('gruvbox').setup({ contrast = 'soft' }) end",
        },
      },
      livePreview = true,
    }
  end,
}
