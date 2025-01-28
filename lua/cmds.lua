-----------------------------------------------------------
--- CODE FOLDING
-----------------------------------------------------------
function Close_all_folds()
  vim.api.nvim_exec2('%foldc!', { output = false })
end
function Open_all_folds()
  vim.api.nvim_exec2('%foldo!', { output = false })
end

-----------------------------------------------------------
-- DiffClipboard
-- create a diff of the clipboard with the current buffer (no ranges)
-----------------------------------------------------------
function DiffClipboard()
  vim.cmd 'let ft=&ft'
  vim.cmd 'vertical new'
  vim.cmd 'setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile'
  vim.cmd '1put'
  vim.cmd 'silent 0d_'
  vim.cmd 'diffthis'
  vim.cmd 'setlocal nomodifiable'
  vim.cmd 'execute "set ft=" . ft'
  vim.cmd 'wincmd p'
  vim.cmd 'diffthis'
end

vim.api.nvim_create_user_command('DiffClipboard', DiffClipboard, { nargs = 0 })

-----------------------------------------------------------
-- Exec
-- execute the current file as a bash script and show the output in a new buffer
-----------------------------------------------------------
function Exec()
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
end

vim.api.nvim_create_user_command('Exec', Exec, { nargs = 0 })

-----------------------------------------------------------
-- QuitAllButCurrent
-- Quit all buffers except the current one and nvim-tree
-----------------------------------------------------------

function QuitAllButCurrent()
  local current_buffer = vim.api.nvim_get_current_buf()

  -- Get a list of all open buffers
  local buffers = vim.api.nvim_list_bufs()

  -- Loop through all buffer handles
  for _, buf in ipairs(buffers) do
    -- Check if the buffer is listed, is not the NvimTree buffer, and is not the current buffer
    if vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buffer and not string.find(vim.api.nvim_buf_get_name(buf), 'NvimTree') then
      -- Delete the buffer if conditions are met
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

-----------------------------------------------------------
-- Lsp_references_excluding_imports_and_tests
-- update goto references to exclude imports and tests
-- NOTE: this doesn't seem to work yet, the tests still show up
-----------------------------------------------------------
function Lsp_references_excluding_imports_and_tests()
  local entry_filter = function(entry)
    -- Example: Exclude entries that contain 'import' in a .ts file
    return not (entry.filename:match '%.ts$' and entry.text:match 'import')
  end

  require('telescope.builtin').lsp_references {
    -- Exclude test files
    file_ignore_patterns = { '%.test%.ts' },
    entry_maker = function(entry)
      if entry_filter(entry) then
        return require('telescope.make_entry').gen_from_quickfix()(entry)
      end
    end,
  }
end
