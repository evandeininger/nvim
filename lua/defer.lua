vim.defer_fn(function()
  require('dapui').setup()
end, 100)

vim.defer_fn(function()
  require('fidget').setup {}
end, 200)
