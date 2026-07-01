-- Native LSP setup (vim.lsp.config + vim.lsp.enable).
-- Loaded as a Lazy plugin via dir = "lua/plugins/coding/native_lsp".

return {
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- LSP incremental sync breaks on some special buffers (nil prev_line in vim.lsp.sync).
    -- nvim-dap REPL uses buftype=prompt; other tools may still attach a client there.
    local function lsp_forbidden_buffer(bufnr)
      if vim.bo[bufnr].buftype == 'prompt' then
        return true
      end
      local ft = vim.bo[bufnr].filetype
      return ft == 'dap-repl' or ft == 'dap-float' or vim.startswith(ft, 'dapui_')
    end

    vim.lsp.config('*', {
      capabilities = capabilities,
      root_markers = { '.git' },
    })

    vim.lsp.config('pyright', {
      cmd = { 'pyright', '--stdio' },
      filetypes = { 'python' },
      root_markers = { '.git', 'pyrightconfig.json', 'setup.py', 'pyproject.toml' },
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = 'workspace',
            typeCheckingMode = 'basic',
          },
        },
      },
      on_init = function(_client, config)
        local venv = vim.env.VIRTUAL_ENV
        if venv then
          local venv_python = venv .. '/bin/python'
          if vim.fn.executable(venv_python) == 1 then
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = venv_python
          end
        end
      end,
    })

    local ts_filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    }
    local ts_ls_settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    }
    -- Start TypeScript server with the project's node_modules binary (absolute path) so it actually runs.
    local function attach_ts_ls(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      if vim.bo[bufnr].buftype ~= '' then
        return
      end
      local path = vim.api.nvim_buf_get_name(bufnr)
      if path == '' or path:match('^%w+://') then
        return
      end
      for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if c.name == 'ts_ls' then
          return
        end
      end
      local root = vim.fs.root(path, { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' })
        or vim.fn.fnamemodify(path, ':p:h')
      local tsserver = root .. '/node_modules/.bin/typescript-language-server'
      local cmd
      if vim.fn.executable(tsserver) == 1 then
        cmd = { tsserver, '--stdio' }
      else
        cmd = { 'npx', '--yes', 'typescript-language-server', '--stdio' }
      end
      vim.lsp.start({
        name = 'ts_ls',
        cmd = cmd,
        root_dir = root,
        capabilities = capabilities,
        filetypes = ts_filetypes,
        single_file_support = true,
        init_options = {
          preferences = {
            disableSuggestions = false,
            includeCompletionsForModuleExports = true,
            includeCompletionsWithInsertText = true,
          },
        },
        settings = ts_ls_settings,
        bufnr = bufnr,
      })
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('native-lsp-ts-start', { clear = true }),
      pattern = ts_filetypes,
      callback = function(ev)
        attach_ts_ls(ev.buf)
      end,
    })

    vim.lsp.config('lua_ls', {
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
      root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
        },
      },
    })

    vim.lsp.config('omnisharp', {
      cmd = { 'omnisharp', '--languageserver' },
      filetypes = { 'cs' },
      root_markers = { '*.sln', '*.csproj', '.git' },
    })

    vim.lsp.enable({ 'pyright', 'lua_ls', 'omnisharp' })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        if lsp_forbidden_buffer(event.buf) then
          -- Neovim runs LspAttach before Client:on_attach sets attached_buffers[bufnr].
          -- A synchronous buf_detach_client here runs changetracking.reset_buf, then
          -- on_attach still sets attached_buffers=true without re-calling changetracking.init.
          -- The next nvim_buf_set_lines (e.g. nvim-dap REPL) then hits send_changes with no buf_state.
          local bufnr, client_id = event.buf, event.data.client_id
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(bufnr) or not lsp_forbidden_buffer(bufnr) then
              return
            end
            if vim.lsp.buf_is_attached(bufnr, client_id) then
              vim.lsp.buf_detach_client(bufnr, client_id)
            end
          end)
          return
        end
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', Snacks.picker.lsp_definitions, '[G]oto [D]efinition')
        map('gr', Snacks.picker.lsp_references, '[G]oto [R]eferences')
        map('gI', Snacks.picker.lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', Snacks.picker.lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', Snacks.picker.lsp_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', Snacks.picker.lsp_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    local function restart_ts_ls()
      for _, c in ipairs(vim.lsp.get_clients { name = 'ts_ls' }) do
        vim.lsp.stop_client(c.id, true)
      end
      vim.defer_fn(function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(bufnr) and vim.tbl_contains(ts_filetypes, vim.bo[bufnr].filetype) then
            attach_ts_ls(bufnr)
          end
        end
      end, 150)
    end

    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      group = vim.api.nvim_create_augroup('restart-ts-server', { clear = true }),
      pattern = { 'tsconfig.json', 'jsconfig.json', 'package.json' },
      callback = restart_ts_ls,
    })

    vim.diagnostic.config({
      virtual_text = { prefix = '●', source = 'if_many' },
      float = { source = 'always', border = 'rounded' },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    vim.api.nvim_create_user_command('TsRestart', function()
      restart_ts_ls()
      vim.defer_fn(function()
        vim.notify('TypeScript server restarted', vim.log.levels.INFO)
      end, 200)
    end, { desc = 'Restart TypeScript Language Server' })
  end,
}
