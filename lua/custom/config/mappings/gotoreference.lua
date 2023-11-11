-- Function to call lsp_references with excluding test files
-- _G.lsp_references_excluding_tests = function() -- _G means it is a global function
--   require('telescope.builtin').lsp_references {
--     file_ignore_patterns = { '%.test%.ts' },
--   }
-- end

-- Define a global function to filter out imports from lsp_references
_G.lsp_references_excluding_imports_and_tests = function()
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

vim.api.nvim_set_keymap(
  'n',
  'gr',
  '<cmd>lua lsp_references_excluding_imports_and_tests()<CR>',
  { noremap = true, silent = true, desc = '[G]oto [R]eferences without tests' }
)
