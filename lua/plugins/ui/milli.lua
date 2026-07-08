local SPLASH = 'shader'

local function ensure_splash(name)
  local registry = require('milli.registry')

  if pcall(require, 'milli.splashes.' .. name) then
    return true
  end
  if registry.load_installed(name) then
    return true
  end
  if vim.fn.executable('curl') ~= 1 then
    return false
  end

  vim.fn.mkdir(registry.install_dir(), 'p')
  local base = vim.g.milli_registry or 'https://raw.githubusercontent.com/amansingh-afk/milli-splashes/main'
  local out = vim.system({ 'curl', '-fsSL', '--max-time', '15', base .. '/splashes/' .. name .. '.lua' }, { text = true }):wait()
  if out.code ~= 0 or not out.stdout or out.stdout == '' then
    return false
  end

  local path = registry.install_dir() .. '/' .. name .. '.lua'
  local f = io.open(path, 'w')
  if not f then
    return false
  end
  f:write(out.stdout)
  f:close()
  return true
end

vim.g.milli_splash = SPLASH

return {
  'amansingh-afk/milli.nvim',
  lazy = false,
  init = function()
    if not ensure_splash(SPLASH) then
      vim.notify('milli.nvim: failed to install splash "' .. SPLASH .. '" (need curl)', vim.log.levels.WARN)
    end
  end,
}
