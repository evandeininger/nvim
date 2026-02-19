return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Track last buffer with a real filename (for tabline when in explorer/dashboard/etc)
    local last_named_file = nil
    local function update_last_named_file()
      local buf = vim.api.nvim_get_current_buf()
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      local name = vim.api.nvim_buf_get_name(buf)
      if name and name ~= '' and vim.bo[buf].buftype == '' then
        last_named_file = name
      end
    end
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = update_last_named_file,
    })

    local function tabline_filename()
      local buf = vim.api.nvim_get_current_buf()
      local name = vim.api.nvim_buf_get_name(buf)
      local buftype = vim.bo[buf].buftype
      -- No name (e.g. explorer, dashboard, [No Name])
      if not name or name == '' or buftype == 'nofile' then
        if last_named_file and last_named_file ~= '' then
          return vim.fn.fnamemodify(last_named_file, ':~:.')
        end
        return '[No Name]'
      end
      return vim.fn.fnamemodify(name, ':~:.')
    end

    require('lualine').setup {
      options = {
        theme = 'duskfox',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { { 'filename', path = 1 } },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'branch' },
      },
      inactive_sections = {
        lualine_a = { { 'branch' } },
        lualine_b = { { 'filename', path = 1 } },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_a = { { 'branch' } },
        lualine_b = { { tabline_filename, color = {} } },
        lualine_c = {},
      },
      extensions = { 'nvim-tree' },
    }
  end,
}
