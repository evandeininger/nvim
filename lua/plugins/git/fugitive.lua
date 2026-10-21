return {
  'tpope/vim-fugitive', -- never enough plugins for git 🙄
  cmd = { 'G', 'Git', 'GBrowse', 'Gdiffsplit', 'Gvdiffsplit', 'Ghdiffsplit', 'Gedit', 'Gsplit', 'Gvsplit', 'Gtabedit', 'Gpedit', 'Gread', 'Gwrite', 'Gwq', 'Ggrep', 'Glgrep', 'Gclog', 'Gllog', 'GMove', 'GRename', 'GDelete', 'GRemove', 'GUnlink', 'Gcd', 'Glcd' },
  dependencies = {
    'tpope/vim-rhubarb', -- :GBrowse for github.com (incl. git@github.com:... remotes)
    'cedarbaum/fugitive-azure-devops.vim', -- :GBrowse for Azure DevOps
  },
}
