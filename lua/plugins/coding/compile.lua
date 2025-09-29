return {
  'pohlrabi404/compile.nvim',
  event = 'VeryLazy',
  opts = {
    cmds = {
      default = 'make -k',
    },

    -- Neutral defaults; layout is set per keymap
    term_win_opts = {
      split = 'below',
      height = 0.4,
    },

    keys = {
      global = {
        ['n'] = {
          -- <leader>cc = horizontal (bottom)
          ['<leader>cc'] = [[
            (function()
              local compile = require('compile')
              compile.compile()              -- open/run default compile
              compile.term.jump_to()         -- focus terminal window
              vim.cmd('wincmd J')            -- move to bottom (horizontal)
              vim.cmd('resize 25')           -- set height in lines; adjust as you like
            end)()
          ]],

          -- <leader>cs = vertical (right)
          ['<leader>cs'] = [[
            (function()
              local compile = require('compile')
              compile.compile()              -- open/run default compile
              compile.term.jump_to()         -- focus terminal window
              vim.cmd('wincmd L')            -- move to right (vertical)
              vim.cmd('vertical resize 80')  -- set width in columns; adjust as you like
            end)()
          ]],

          -- Optional navigation keys
          ['<localleader>cn'] = "require('compile').next_error()",
          ['<localleader>cp'] = "require('compile').prev_error()",
          ['<localleader>cl'] = "require('compile').last_error()",
          ['<localleader>cf'] = "require('compile').first_error()",
          ['<localleader>cj'] = "require('compile').term.jump_to()",
        },
      },
    },
  },
}
