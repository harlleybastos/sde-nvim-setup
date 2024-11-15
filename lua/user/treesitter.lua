-- ~/.config/nvim/lua/user/treesitter.lua
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    -- Web Development
    "javascript",
    "typescript",
    "tsx",
    "html",
    "css",
    "json",
    
    -- Config files
    "yaml",
    "toml",
    "dockerfile",
    
    -- General
    "vim",
    "lua",
    "markdown",
    "markdown_inline",
    "regex",
    "bash",
    "git_config",
    "gitignore"
  },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      node_decremental = "<BS>",
      scope_incremental = "<TAB>",
    },
  },
}
