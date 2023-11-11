function DiffClipboard()
  vim.cmd('let ft=&ft')
  vim.cmd('vertical new')
  vim.cmd('setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile')
  vim.cmd('1put')
  vim.cmd('silent 0d_')
  vim.cmd('diffthis')
  vim.cmd('setlocal nomodifiable')
  vim.cmd('execute "set ft=" . ft')
  vim.cmd('wincmd p')
  vim.cmd('diffthis')
end

vim.cmd('command! DiffClipboard lua DiffClipboard()')

