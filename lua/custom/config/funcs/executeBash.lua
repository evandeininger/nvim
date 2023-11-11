vim.api.nvim_create_user_command('Exec', function()
  local buf_name = '__ExecOutput__'
  local buf = vim.fn.bufnr(buf_name)
  local current_file = vim.fn.expand '%:p'
  local original_win = vim.api.nvim_get_current_win()
  local output = vim.fn.systemlist('bash ' .. current_file)

  -- Check if the buffer already exists
  if buf == -1 then
    -- Create a new buffer
    vim.cmd 'vnew'
    buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_name(buf, buf_name)
    vim.cmd 'set filetype=sh'
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  else
    -- Reuse the existing buffer
    local win_id = vim.fn.bufwinid(buf)
    if win_id ~= -1 then
      vim.api.nvim_set_current_win(win_id)
    else
      vim.cmd('vsplit ' .. buf_name)
    end
    buf = vim.fn.bufnr(buf_name)
  end

  -- Clear the buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  -- Run the current file as a bash script and read its output into the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

  -- Switch back to the original window
  vim.api.nvim_set_current_win(original_win)
end, { nargs = 0 })
