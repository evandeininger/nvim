return {
  'folke/sidekick.nvim',
  opts = {
    -- Disable NES in terminal buffers to avoid cursor/redraw issues when typing in the CLI prompt
    nes = {
      enabled = function(buf)
        buf = buf or vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_valid(buf) then
          return false
        end
        if vim.bo[buf].buftype == 'terminal' then
          return false
        end
        return vim.g.sidekick_nes ~= false and vim.b.sidekick_nes ~= false
      end,
    },
    cli = {
      mux = {
        backend = 'tmux',
        enabled = true,
      },
      -- Add or override prompts. Use <leader>ap to pick one.
      -- Placeholders: {file}, {this}, {selection}, {quickfix}, {buffers},
      --   {line}, {position}, {diagnostics}, {diagnostics_all}, {function}, {class}
      prompts = {
        -- Override built-ins by using the same key:
        -- explain = "Explain {this} in simple terms",
        -- fix = "Fix {this} and explain the change",
        -- Custom prompts (show up in the prompt picker):
        refactor = 'Refactor {this} to be more maintainable',
        -- security = "Review {file} for security issues",
        -- With a function for dynamic content:
        -- custom = function(ctx)
        --   return string.format("Help with buffer %s at line %d", ctx.buf or "?", ctx.row or 0)
        -- end,
      },
    },
  },
  keys = {
    {
      '<tab>',
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>' -- fallback to normal tab
        end
      end,
      mode = 'n',
      expr = true,
      desc = 'Goto/Apply Next Edit Suggestion',
    },
    {
      '<c-.>',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle',
      mode = { 'n', 't', 'i', 'x' },
    },
    {
      '<leader>aa',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle CLI',
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = 'Select CLI',
    },
    {
      '<leader>ad',
      function()
        require('sidekick.cli').close()
      end,
      desc = 'Detach a CLI Session',
    },
    {
      '<leader>at',
      function()
        require('sidekick.cli').send { msg = '{this}' }
      end,
      mode = { 'x', 'n' },
      desc = 'Send This',
    },
    {
      '<leader>af',
      function()
        require('sidekick.cli').send { msg = '{file}' }
      end,
      desc = 'Send File',
    },
    {
      '<leader>aq',
      function()
        local qf = vim.fn.getqflist()
        local seen = {}
        local paths = {}
        for _, item in ipairs(qf) do
          local f = item.filename and #item.filename > 0 and item.filename or vim.fn.bufname(item.bufnr)
          if f and #f > 0 and not seen[f] then
            seen[f] = true
            local rel = vim.fn.fnamemodify(f, ':~:.')
            table.insert(paths, '@' .. rel)
          end
        end
        if #paths == 0 then
          vim.notify('Quickfix list is empty', vim.log.levels.WARN)
          return
        end
        require('sidekick.cli').send { msg = table.concat(paths, '\n') }
      end,
      desc = 'Send Quickfix Files Only',
    },
    {
      '<leader>av',
      function()
        require('sidekick.cli').send { msg = '{selection}' }
      end,
      mode = { 'x' },
      desc = 'Send Visual Selection',
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      mode = { 'n', 'x' },
      desc = 'Sidekick Select Prompt',
    },
    {
      '<leader>ac',
      function()
        require('sidekick.cli').toggle { name = 'cursor', focus = true }
      end,
      desc = 'Sidekick Toggle Cursor',
    },
  },
}
