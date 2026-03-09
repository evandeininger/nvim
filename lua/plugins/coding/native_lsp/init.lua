-- Native LSP setup (vim.lsp.config + vim.lsp.enable).
-- Loaded as a Lazy plugin via dir = "lua/plugins/coding/native_lsp".

return {
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

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
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('native-lsp-ts-start', { clear = true }),
      pattern = ts_filetypes,
      callback = function(ev)
        local bufnr = ev.buf
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
          -- Fallback: npx uses project node_modules or runs from cache (npm i -D typescript-language-server in project if needed)
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

    vim.lsp.enable({ 'pyright', 'lua_ls' })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
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

    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      group = vim.api.nvim_create_augroup('restart-ts-server', { clear = true }),
      pattern = { 'tsconfig.json', 'jsconfig.json', 'package.json' },
      callback = function()
        vim.cmd('lsp restart ts_ls')
      end,
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
      vim.cmd('lsp stop ts_ls')
      vim.defer_fn(function()
        vim.cmd('lsp enable ts_ls')
        vim.notify('TypeScript server restarted', vim.log.levels.INFO)
      end, 500)
    end, { desc = 'Restart TypeScript Language Server' })
  end,
}
