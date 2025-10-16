-- lua/plugins/oil.lua
return {
  'stevearc/oil.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  lazy = false,
  config = function()
    vim.opt.termguicolors = true

    -- Define and persist custom float highlight groups for Oil
    local function set_oil_float_hl()
      vim.api.nvim_set_hl(0, 'OilNormalFloat', { bg = '#1a1a1a', fg = '#c0c0c0' })
      vim.api.nvim_set_hl(0, 'OilFloatBorder', { fg = '#3a3a3a', bg = '#1a1a1a' })
    end
    set_oil_float_hl()
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = set_oil_float_hl,
      desc = 'Persist Oil float highlight groups across colorscheme changes',
    })

    require('oil').setup {
      columns = { 'icon' },
      float = {
        win_options = {
          winblend = 0,
          winhl = 'Normal:OilNormalFloat,FloatBorder:OilFloatBorder',
        },
      },
      preview_win = {
        win_options = {
          winblend = 0,
          winhl = 'Normal:OilNormalFloat,FloatBorder:OilFloatBorder',
        },
      },
      keymaps = {
        ['q'] = { 'actions.close', mode = 'n' },
        ['<esc>'] = { 'actions.close', mode = 'n' },
      },
      view_options = { show_hidden = true },
    }

    -- Open parent directory in floating window
    vim.keymap.set('n', '<space>tt', require('oil').toggle_float)
  end,
}
