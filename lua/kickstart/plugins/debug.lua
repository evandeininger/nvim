-- nvim-dap + dap-ui + dap-go. Adapters are manual (see :help dap-adapter).

return {
  'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'leoluz/nvim-dap-go',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- nvim-dap picks configs from the current buffer's filetype; Snacks pickers use non-code
    -- filetypes, so run buffer-sensitive actions from a window that shows real source (#).
    local picker_ft = {
      snacks_picker_list = true,
      snacks_picker_input = true,
      snacks_picker_preview = true,
    }

    local function win_for_buf(bufnr)
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_buf(win) == bufnr then
          return win
        end
      end
    end

    local function with_code_win(fn)
      if not picker_ft[vim.bo.filetype] then
        fn()
        return
      end
      local alt = vim.fn.bufnr '#'
      if alt < 1 or not vim.api.nvim_buf_is_valid(alt) or picker_ft[vim.bo[alt].filetype] then
        vim.notify('DAP: focus a source buffer or close the picker, then try again.', vim.log.levels.WARN)
        return
      end
      local win = win_for_buf(alt)
      if not win then
        vim.notify('DAP: no window is showing the code buffer (alternate #).', vim.log.levels.WARN)
        return
      end
      vim.api.nvim_win_call(win, fn)
    end

    return {
      { '<F5>', function() with_code_win(function() dap.continue() end) end, desc = 'Debug: Start/Continue' },
      { '<F1>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F2>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F3>', dap.step_out, desc = 'Debug: Step Out' },
      {
        '<leader>b',
        function() with_code_win(function() dap.toggle_breakpoint() end) end,
        desc = 'Debug: Toggle Breakpoint',
      },
      {
        '<leader>B',
        function()
          with_code_win(function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
          end)
        end,
        desc = 'Debug: Set Breakpoint',
      },
      { '<F7>', dapui.toggle, desc = 'Debug: Toggle DAP UI' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local data = vim.fn.stdpath 'data'
    local session_file = data .. '/last_dap_session.json'

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for kind, text in pairs(icons) do
      local name = 'Dap' .. kind
      local hl = kind == 'Stopped' and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(name, { text = text, texthl = hl, numhl = hl })
    end

    local function save_last_session()
      local session = dap.session()
      if not session then
        return
      end
      local f, err = io.open(session_file, 'w')
      if not f then
        vim.notify('DAP: could not save session (' .. tostring(err) .. ')', vim.log.levels.ERROR)
        return
      end
      f:write(vim.fn.json_encode(vim.deepcopy(session.config)))
      f:close()
      vim.notify('DAP session saved.', vim.log.levels.INFO)
    end

    local function load_last_session()
      if dap.session() then
        vim.notify('DAP: already attached.', vim.log.levels.INFO)
        return
      end
      local f = io.open(session_file, 'r')
      if not f then
        vim.notify('DAP: no saved session at ' .. session_file, vim.log.levels.WARN)
        return
      end
      local json = f:read '*a'
      f:close()
      local config = vim.fn.json_decode(json)
      if config then
        dap.run(config)
      end
    end

    local reconnect_armed = false
    local function schedule_reconnect()
      if reconnect_armed then
        return
      end
      reconnect_armed = true
      vim.defer_fn(function()
        reconnect_armed = false
        if dap.session() then
          return
        end
        load_last_session()
      end, 500)
    end

    vim.keymap.set('n', '<leader>dS', save_last_session, { desc = 'Save DAP session' })
    vim.keymap.set('n', '<leader>dl', load_last_session, { desc = 'Load last DAP session' })

    -- Open with session; close on normal teardown, disconnect, or abrupt adapter loss (on_close).
    dap.listeners.after.event_initialized['dapui_config'] = function(sess)
      sess.on_close['kickstart.dapui'] = function()
        vim.schedule(function()
          if not dap.session() then
            dapui.close()
          end
        end)
      end
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
    dap.listeners.after.terminate['dapui_config'] = dapui.close
    dap.listeners.before.disconnect['dapui_config'] = dapui.close

    dap.listeners.after.event_terminated['dap_reconnect'] = schedule_reconnect
    dap.listeners.after.event_exited['dap_reconnect'] = schedule_reconnect

    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }

    dap.adapters.coreclr = {
      type = 'executable',
      command = 'netcoredbg',
      args = { '--interpreter=vscode' },
    }

    dap.configurations.cs = {
      {
        type = 'coreclr',
        request = 'launch',
        name = 'Launch .NET Core',
        program = function()
          return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
      },
      {
        type = 'coreclr',
        request = 'attach',
        name = 'Attach to process',
        processId = require('dap.utils').pick_process,
      },
    }

    dap.adapters.python = function(cb, config)
      if config.request == 'attach' then
        ---@diagnostic disable-next-line: undefined-field
        local connect = config.connect or config
        cb({
          type = 'server',
          port = assert(connect.port, '`connect.port` is required for python attach'),
          host = connect.host or '127.0.0.1',
          options = { source_filetype = 'python' },
        })
      else
        cb({
          type = 'executable',
          command = 'debugpy-adapter',
          options = { source_filetype = 'python' },
        })
      end
    end

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          for _, rel in ipairs { '/venv/bin/python', '/.venv/bin/python' } do
            local p = cwd .. rel
            if vim.fn.executable(p) == 1 then
              return p
            end
          end
          return '/usr/bin/python3'
        end,
      },
    }

    -- Optional: extract vscode-js-debug `js-debug-dap-*.tar.gz` under this path so
    -- `js-debug/src/dapDebugServer.js` exists (see microsoft/vscode-js-debug releases).
    local js_server = data .. '/js-debug-dap/js-debug/src/dapDebugServer.js'
    if vim.fn.filereadable(js_server) == 1 then
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { js_server, '${port}' },
        },
      }
      local node = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
          sourceMaps = true,
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
        },
      }
      dap.configurations.javascript = node
      dap.configurations.typescript = node
    end
  end,
}
