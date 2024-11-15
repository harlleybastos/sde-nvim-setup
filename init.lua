-- ~/.config/nvim/init.lua
require('user.options')
require('user.keymaps')  -- We'll create this for keybindings
require('user.plugins')
require('user.treesitter')
require('user.lsp')

-- Set colorscheme
vim.cmd[[colorscheme dracula]]

-- Setup nvim-tree
require('nvim-tree').setup{}

-- Setup telescope
require('telescope').setup{}
