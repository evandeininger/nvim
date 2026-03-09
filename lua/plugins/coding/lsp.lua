return {
  -- LSP-related plugins (native vim.lsp only; no nvim-lspconfig or Mason)
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    'j-hui/fidget.nvim',
    event = 'VeryLazy',
    opts = {
      -- Show LSP progress (e.g. "Loading...", "Indexing") when servers start
      progress = {
        display = {
          progress_icon = { 'dots' },
          done_icon = '✔',
          progress_ttl = math.huge,
          done_ttl = 2,
        },
      },
    },
  },
  {
    'hrsh7th/cmp-nvim-lsp',
    lazy = true,
  },
  -- Native LSP: vim.lsp.config() + vim.lsp.enable() (config in lua/plugins/coding/native_lsp/)
  -- Install language servers yourself (e.g. npm i -g typescript-language-server, pip install pyright).
  -- See :help lsp-quickstart and https://microsoft.github.io/language-server-protocol/implementors/servers/
  {
    dir = vim.fn.stdpath('config') .. '/lua/plugins/coding/native_lsp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      require('plugins.coding.native_lsp').config()
    end,
  },
}
