-- AUTO SAVING
-- autosave all the time
vim.cmd([[ au TextChanged,InsertLeave * :w ]])

-- save on focus out
vim.cmd([[ au FocusLost * :w ]])
