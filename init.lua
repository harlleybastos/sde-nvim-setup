-- ~/.config/nvim/init.lua
-- Load options and keymaps BEFORE plugins
require('user.options')
require('user.keymaps')

-- Bootstrap and load plugins (lazy.nvim)
require('user.plugins')

-- Plugin configs are loaded via lazy.nvim config functions
-- See lua/user/plugins.lua for the full plugin spec
