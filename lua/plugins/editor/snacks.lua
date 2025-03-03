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
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = {
      ui_select = true,
      win = {
        input = {
          keys = {
            ["<C-c>"] = { "cancel", mode = "i" },
          },
        },
      },
    },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    profile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>sh", function() require("snacks").picker.help() end, desc = "[S]earch [H]elp" },
    { "<leader>sk", function() require("snacks").picker.keymaps() end, desc = "[S]earch [K]eymaps" },
    { "<leader>sf", function() require("snacks").picker.files() end, desc = "[S]earch [F]iles" },
    { "<leader>ss", function() require("snacks").picker() end, desc = "[S]earch [S]elect Picker" },
    { "<leader>sw", function() require("snacks").picker.grep_word() end, desc = "[S]earch current [W]ord" },
    { "<leader>sg", function() require("snacks").picker.grep() end, desc = "[S]earch by [G]rep" },
    { "<leader>sd", function() require("snacks").picker.diagnostics() end, desc = "[S]earch [D]iagnostics" },
    { "<leader>sr", function() require("snacks").picker.resume() end, desc = "[S]earch [R]esume" },
    { "<leader>s.", function() require("snacks").picker.recent() end, desc = "[S]earch Recent Files" },
    { "<leader><leader>", function() require("snacks").picker.buffers() end, desc = "[ ] Find existing buffers" },
    { "<leader>gs", function() require("snacks").picker.git_status() end, desc = "[G]it [S]tatus" },
    { "<leader>/", function() require("snacks").picker.lines() end, desc = "[/] Search in current buffer" },
    { "<leader>s/", function() 
      require("snacks").picker.grep({ buffers = true }) 
    end, desc = "[S]earch [/] in Open Files" },
    { "<leader>sn", function()
      require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
    end, desc = "[S]earch [N]eovim files" },
    { "<leader>gc", function() require("snacks").picker.git_commits() end, desc = "[G]it [C]ommits" },
    { "<leader>gb", function() require("snacks").picker.git_branches() end, desc = "[G]it [B]ranches" },
    { "<leader>gf", function() require("snacks").picker.git_files() end, desc = "[G]it [F]iles" },
  }
}
