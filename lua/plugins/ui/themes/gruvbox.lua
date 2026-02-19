--- Gruvbox colorscheme. Theme variant (hard/soft) is applied only via Themery's before callback.
--- No setup() here so contrast is never overwritten when the plugin loads.
return {
  'ellisonleao/gruvbox.nvim',
  priority = 1000,
  lazy = true,
}
