-- Loaded via `nvim --cmd 'luafile scripts/bench-probe.lua'`.
-- Records: uienter_ms, verylazy_ms (time until VeryLazy plugins finish), and
-- event-loop lag (max/avg ms) over 1.5s while the dashboard is idle/animating.
local t0 = vim.uv.hrtime()
local out = vim.env.NVIM_BENCH_OUT
local r = {}
local function ms() return (vim.uv.hrtime() - t0) / 1e6 end

vim.api.nvim_create_autocmd('UIEnter', { once = true, callback = function() r.uienter = ms() end })

local function finish()
  local f = io.open(out, 'w')
  f:write(string.format('uienter=%.1f verylazy=%.1f lag_max=%.1f lag_avg=%.1f\n',
    r.uienter or -1, r.verylazy or -1, r.lag_max or -1, r.lag_avg or -1))
  f:close()
  vim.cmd 'qa!'
end

local function measure_lag()
  local interval, n, total, max = 10, 0, 0, 0
  local last = vim.uv.hrtime()
  local timer = vim.uv.new_timer()
  timer:start(interval, interval, vim.schedule_wrap(function()
    local now = vim.uv.hrtime()
    local lag = (now - last) / 1e6 - interval
    last = now
    n, total, max = n + 1, total + math.max(lag, 0), math.max(max, lag)
    if n >= 150 then
      timer:stop()
      r.lag_max, r.lag_avg = max, total / n
      finish()
    end
  end))
end

vim.api.nvim_create_autocmd('User', { pattern = 'VeryLazy', once = true, callback = function()
  vim.schedule(function()
    r.verylazy = ms()
    measure_lag()
  end)
end })

-- Safety net if VeryLazy never fires.
vim.defer_fn(function() if not r.verylazy then finish() end end, 15000)
