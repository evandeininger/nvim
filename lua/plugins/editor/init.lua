return {
  { import = 'plugins.editor.visual-multi' }, -- multiple cursors for editing
  { import = 'plugins.editor.tmux' }, -- tmux navigation integration
  { import = 'plugins.editor.flash' }, -- enhanced motion/navigation
  { import = 'plugins.editor.recall' }, -- mark management
  { import = 'plugins.editor.bqf' }, -- better quickfix window
  {
    import = 'plugins.editor.snacks',
  },
  { import = 'plugins.editor.mini' }, -- text objects and surround
  -- { import = 'plugins.editor.oil' }, -- file explorer, currently disabled in favor of snacks explorer
}
