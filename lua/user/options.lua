-- ~/.config/nvim/lua/user/options.lua
local options = {
  number = true,
  termguicolors = true,
  expandtab = true,
  relativenumber = true,
  shiftwidth = 2,
  tabstop = 2,
  smartindent = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
