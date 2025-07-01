return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
 ▄▄▄▄   ▄███████▓  ██████ 
▓█████▄    ██▒ ▓▒▒██    ▒ 
▒██▒ ▄██▒ ▓██░ ▒░░ ▓██▄   
▒██░█▀  ░ ▓██▓ ░   ▒   ██▒
░▓█  ▀█▓  ▒██▒ ░ ▒██████▒▒
░▒████▀▒  ▒ ░░   ▒ ▒▓▒ ▒ ░
▒░▒   ░     ░    ░ ░▒  ░ ░
 ░    ░   ░      ░  ░  ░  
 ░                     ░  
      ░                   
        ]],
      },
    },
    -- indent = { enabled = true },
    -- input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    -- scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    -- too many issues with git status, explorer having extra files etc, going to wait for maturity
    explorer = {
      enabled = true,
    },
    picker = {
      filter = { cwd = true },
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
          jump = { close = true }, -- Close explorer after selecting a file
          actions = {
            copy_path = function(_, item)
              local modify = vim.fn.fnamemodify

              local filepath = item.file
              local filename = modify(filepath, ':t')

              local results = {
                filepath,
                modify(filepath, ':.'),
                modify(filepath, ':~'),
                filename,
                modify(filename, ':r'),
                modify(filename, ':e'),
              }

              local items = {
                'Absolute path: ' .. results[1],
                'Path relative to CWD: ' .. results[2],
                'Path relative to HOME: ' .. results[3],
                'Filename: ' .. results[4],
              }

              if vim.fn.isdirectory(filepath) == 0 then
                vim.list_extend(items, {
                  'Filename without extension: ' .. results[5],
                  'Extension of the filename: ' .. results[6],
                })
              end

              vim.ui.select(items, { prompt = 'Choose to copy to clipboard:' }, function(choice, i)
                if not choice then
                  vim.notify 'Selection cancelled'
                  return
                end
                if not i then
                  vim.notify 'Invalid selection'
                  return
                end
                local result = results[i]
                vim.fn.setreg('*', result)
                vim.notify('Copied: ' .. result)
              end)
            end,
            search_in_directory = {
              action = function(_, item)
                if not item then
                  return
                end
                local dir = vim.fn.fnamemodify(item.file, ':p:h')
                Snacks.picker.grep {
                  cwd = dir,
                  cmd = 'rg',
                  show_empty = true,
                  hidden = true,
                  ignored = true,
                  follow = false,
                  supports_live = true,
                }
              end,
            },
          },
          win = {
            list = {
              keys = {
                ['s'] = 'search_in_directory',
                ['Y'] = 'copy_path',
              },
            },
          },
        },
      },
      ui_select = true,
      win = {
        input = {
          keys = {
            ['<C-c>'] = { 'cancel', mode = 'i' },
          },
        },
      },
    },
  },
  keys = {
    -- git
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    -- explorer
    {
      '<leader>tt',
      function()
        Snacks.explorer()
      end,
      desc = 'Explorer',
    },
    -- picker
    {
      '<leader>sh',
      function()
        require('snacks').picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        require('snacks').picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sf',
      function()
        require('snacks').picker.smart()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>ss',
      function()
        require('snacks').picker()
      end,
      desc = '[S]earch [S]elect Picker',
    },
    {
      '<leader>sw',
      function()
        require('snacks').picker.grep_word()
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>sg',
      function()
        require('snacks').picker.grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sd',
      function()
        require('snacks').picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        require('snacks').picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>s.',
      function()
        require('snacks').picker.recent()
      end,
      desc = '[S]earch Recent Files',
    },
    {
      '<leader><leader>',
      function()
        require('snacks').picker.buffers()
      end,
      desc = '[ ] Find existing buffers',
    },
    {
      -- notifier history show
      '<leader>nh',
      function()
        require('snacks').notifier.show_history()
      end,
      desc = '[N]otifier [H]istory',
    },
    {
      '<leader>gs',
      function()
        require('snacks').picker.git_status { filter = { cwd = true }, cwd = vim.fn.getcwd() }
      end,
      desc = '[G]it [S]tatus',
    },
    {
      '<leader>/',
      function()
        require('snacks').picker.lines()
      end,
      desc = '[/] Search in current buffer',
    },
    {
      '<leader>s/',
      function()
        require('snacks').picker.grep { buffers = true }
      end,
      desc = '[S]earch [/] in Open Files',
    },
    {
      '<leader>gB',
      function()
        require('snacks').picker.git_branches()
      end,
      desc = '[G]it [B]ranches',
    },
    {
      '<leader>gf',
      function()
        require('snacks').picker.git_files { filter = { cwd = true } }
      end,
      desc = '[G]it [F]iles',
    },
  },
}
