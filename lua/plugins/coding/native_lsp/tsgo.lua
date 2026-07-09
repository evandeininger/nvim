--- TypeScript/JavaScript LSP with repo-local binary resolution.
--- Prefers TypeScript 7 native LSP (`tsc --lsp --stdio` or nightly `tsgo`).
--- Falls back to `typescript-language-server` for projects still on TypeScript 5/6.
local M = {}

local ts_filetypes = {
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
}

local missing_notified = {} ---@type table<string, boolean>
local lsp_support_cache = {} ---@type table<string, boolean>
local cmd_by_root = {} ---@type table<string, string[]>
local pending_cmd ---@type string[]?

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

local ts7_settings = {
  typescript = {
    inlayHints = {
      parameterNames = {
        enabled = 'literals',
        suppressWhenArgumentMatchesName = true,
      },
      parameterTypes = { enabled = true },
      variableTypes = { enabled = true },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = true },
      enumMemberValues = { enabled = true },
    },
  },
}

local function buf_path(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' or path:match('^%w+://') then
    return nil
  end
  return path
end

local function is_executable(bin)
  if vim.fn.executable(bin) == 1 then
    return true
  end
  return vim.fn.filereadable(bin) == 1
end

local function tsc_major_version(bin)
  if not is_executable(bin) then
    return nil
  end
  local out = vim.system({ bin, '--version' }, { text = true }):wait()
  return out.stdout and tonumber(out.stdout:match('Version (%d+)'))
end

local function supports_ts7_lsp(bin)
  if lsp_support_cache['ts7:' .. bin] ~= nil then
    return lsp_support_cache['ts7:' .. bin]
  end

  local name = vim.fn.fnamemodify(bin, ':t')
  if name == 'tsgo' then
    lsp_support_cache['ts7:' .. bin] = is_executable(bin)
    return lsp_support_cache['ts7:' .. bin]
  end

  local major = tsc_major_version(bin)
  lsp_support_cache['ts7:' .. bin] = major ~= nil and major >= 7
  return lsp_support_cache['ts7:' .. bin]
end

--- Nearest Node/Yarn workspace root for monorepos (lockfile wins over package.json).
local function project_root(bufnr)
  local path = buf_path(bufnr)
  if not path then
    return nil
  end

  local lock_markers = { 'yarn.lock', 'package-lock.json', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  local root = vim.fs.root(path, lock_markers) or vim.fs.root(path, { 'package.json', '.git' })

  local deno_root = vim.fs.root(path, { 'deno.json', 'deno.jsonc' })
  local deno_lock_root = vim.fs.root(path, { 'deno.lock' })

  if deno_lock_root and (not root or #deno_lock_root > #root) then
    return nil
  end
  if deno_root and (not root or #deno_root >= #root) then
    return nil
  end

  return root
end

--- TypeScript 7 native LSP: repo-local `tsc`/`tsgo`, then PATH.
local function ts7_cmd(root_dir)
  local candidates = {}
  if root_dir then
    candidates[#candidates + 1] = vim.fs.joinpath(root_dir, 'node_modules/.bin/tsc')
    candidates[#candidates + 1] = vim.fs.joinpath(root_dir, 'node_modules/.bin/tsgo')
  end
  candidates[#candidates + 1] = 'tsc'
  candidates[#candidates + 1] = 'tsgo'

  for _, bin in ipairs(candidates) do
    if supports_ts7_lsp(bin) then
      return { bin, '--lsp', '--stdio' }
    end
  end
end

--- Classic LSP for TypeScript 5/6: repo-local `typescript-language-server`, then npx.
local function ts_ls_cmd(root_dir)
  if root_dir then
    local local_tls = vim.fs.joinpath(root_dir, 'node_modules/.bin/typescript-language-server')
    if is_executable(local_tls) then
      return { local_tls, '--stdio' }
    end
  end
  if is_executable('typescript-language-server') then
    return { 'typescript-language-server', '--stdio' }
  end
  if vim.fn.executable('npx') == 1 then
    return { 'npx', '--yes', 'typescript-language-server', '--stdio' }
  end
end

--- Resolve the best TypeScript LSP command for a project root.
local function resolve_ts_cmd(root_dir)
  return ts7_cmd(root_dir) or ts_ls_cmd(root_dir)
end

function M.setup(capabilities)
  vim.lsp.config('tsgo', {
    capabilities = capabilities,
    filetypes = ts_filetypes,
    init_options = {
      preferences = {
        disableSuggestions = false,
        includeCompletionsForModuleExports = true,
        includeCompletionsWithInsertText = true,
      },
    },
    settings = vim.tbl_deep_extend('force', ts_ls_settings, ts7_settings),
    -- Neovim 0.11.1 calls cmd(dispatchers) only; root_dir stashes the resolved
    -- command in pending_cmd / cmd_by_root before the client starts.
    cmd = function(dispatchers, config)
      local root = config and config.root_dir
      local cmd = (root and cmd_by_root[root]) or pending_cmd or resolve_ts_cmd(root)
      pending_cmd = nil
      if not cmd then
        vim.notify(
          'TypeScript LSP not found — install typescript@^7 or typescript-language-server in the project',
          vim.log.levels.ERROR
        )
        error('tsgo: no TypeScript LSP binary')
      end
      return vim.lsp.rpc.start(cmd, dispatchers)
    end,
    root_dir = function(bufnr, on_dir)
      local root = project_root(bufnr)
      if not root then
        return
      end
      local cmd = resolve_ts_cmd(root)
      if not cmd then
        if not missing_notified[root] then
          missing_notified[root] = true
          vim.notify(
            'TypeScript LSP not found for ' .. root .. ' — add typescript@^7 or typescript-language-server',
            vim.log.levels.WARN
          )
        end
        return
      end
      cmd_by_root[root] = cmd
      pending_cmd = cmd
      on_dir(root)
    end,
  })

  vim.lsp.enable('tsgo')
end

function M.restart()
  vim.lsp.enable('tsgo', false)
  vim.defer_fn(function()
    vim.lsp.enable('tsgo', true)
  end, 150)
end

function M.filetypes()
  return ts_filetypes
end

function M.resolve_ts_cmd(root_dir)
  return resolve_ts_cmd(root_dir)
end

return M
