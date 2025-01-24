return {
  {
    -- add support for tmux navigation in vim using vim motions
    'christoomey/vim-tmux-navigator',
  },
  {
    -- add support for github copilot
    -- "github/copilot.vim", -- ditching this for something written in lua for performance purposes
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = 'gr',
            open = '<M-CR>',
          },
          layout = {
            position = 'bottom', -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = '<M-l>',
            accept_word = false,
            accept_line = false,
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ['.'] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
      }
    end,
  },
  {
    'jackMort/ChatGPT.nvim',
    event = 'VeryLazy',
    config = function()
      require('chatgpt').setup()
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
  },
  -- {
  --   -- add tabs for each open buffer
  --   'akinsho/bufferline.nvim',
  --   version = '*',
  --   dependencies = 'nvim-tree/nvim-web-devicons',
  --   config = function()
  --     require('bufferline').setup {
  --       options = {
  --         modified_icon = '●',
  --       },
  --     }
  --   end,
  -- },
  {
    -- add support for multicursor
    'mg979/vim-visual-multi',
  },
  {
    -- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists to help you solve all the trouble your code is causing.
    -- https://github.com/folke/trouble.nvim
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    -- make the background transparent
    'xiyaowong/transparent.nvim',
    config = function()
      -- vim.g.transparent_groups = vim.list_extend(
      --   vim.g.transparent_groups or {},
      --   vim.tbl_map(function(v)
      --     return v.hl_group
      --   end, vim.tbl_values(require('bufferline.config').highlights))
      -- )
      -- require('transparent').clear_prefix 'BufferLine'
      require('transparent').clear_prefix 'NvimTree'
      -- require('transparent').clear_prefix('lualine')
    end,
  },
  {
    -- prisma highlighting.
    'prisma/vim-prisma',
  },
  {
    -- lazygit integration, must have lazygit installed
    'kdheepak/lazygit.nvim',
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
  {
    -- file tree
    'nvim-tree/nvim-tree.lua',
    version = '*',
    -- lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {

        filters = {
          -- hopeing this reduces resource demand in tree, otherwise try: node_modules/.*
          custom = { 'node_modules/.*' },
        },
        -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
        open_on_tab = false,
        -- hijack the cursor in the tree to put it at the start of the filename
        hijack_cursor = true,
        -- show lsp diagnostics in the signcolumn
        diagnostics = {
          enable = true,
          icons = {
            hint = '',
            info = '',
            warning = '',
            error = '',
          },
        },
        -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
        update_focused_file = {
          enable = true,
        },
        renderer = {
          highlight_opened_files = 'all',
        },
        view = {
          side = 'right',
          width = 60,
        },
        git = {
          ignore = false,
          enable = true,
        },
        -- configuration options for the system open command (`s` in the tree by default)
        system_open = {
          -- the command to run this, leaving nil should work in most cases
          cmd = nil,
          -- the command arguments as a list
          args = {},
        },
      }
    end,
  },
  -- {
  --   -- only leave edited tabs open
  --   'axkirillov/hbac.nvim',
  --   dependencies = {
  --       -- these are optional, add them, if you want the telescope module
  --       'nvim-telescope/telescope.nvim',
  --       'nvim-lua/plenary.nvim',
  --       'nvim-tree/nvim-web-devicons'
  --   },
  --   config = function()
  --       require("hbac").setup({
  --           threshold = 3,
  --       })
  --   end
  -- },
  -- {
  --     -- preeeeettttyyyyy
  --     'loctvl842/monokai-pro.nvim',
  --     config = function()
  --         require("monokai-pro").setup({
  --             filter = 'octagon'
  --         })
  --         vim.cmd.colorscheme 'monokai-pro'
  --     end
  -- },
  {
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
  },
  {
    -- use fugitive GBrowse to open in devops
    'cedarbaum/fugitive-azure-devops.vim',
  },
  -- { 'nvim-neotest/nvim-nio' },
  -- {
  --   'mfussenegger/nvim-dap',
  -- },
  -- {
  --   'mxsdev/nvim-dap-vscode-js',
  --   build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
  --   dependencies = { 'mfussenegger/nvim-dap' },
  -- },
  -- { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap' }, lazy = true },
  {
    'Joakker/lua-json5',
    build = './install.sh',
    lazy = true,
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    'sindrets/diffview.nvim',
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'duskfox',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { { 'filename', path = 1 } },
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'branch' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { 'nvim-tree' },
      }
    end,
  },
  {
    -- never enough plugins for git 🙄
    'tpope/vim-fugitive',
  },
  {
    -- make quickfix list better
    'kevinhwang91/nvim-bqf',
  },
  {
    'fnune/recall.nvim',
    version = '*',
    config = function()
      local recall = require 'recall'

      recall.setup {
        sign = '',
        sign_highlight = '',
      }

      vim.keymap.set('n', '<leader>mm', recall.toggle, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>mn', recall.goto_next, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>mp', recall.goto_prev, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>mc', recall.clear, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>ml', ':Telescope recall<CR>', { noremap = true, silent = true })
    end,
  },
  {
    -- sticky scroll similar to vscode
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesitter-context').setup {
        enable = true, -- Enable the plugin
        max_lines = 0, -- No limit on context lines
        trim_scope = 'outer', -- Discard outer context if max_lines is exceeded
        mode = 'cursor', -- Line used to calculate context: 'cursor', 'topline'
        separator = nil, -- No separator between context and content
        zindex = 20, -- Z-index for the context window
        on_attach = nil, -- Function to run when attaching
      }
    end,
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup {
        level = 2,
        render = 'compact',
      }
      vim.notify = require 'notify'
    end,
  },
}
