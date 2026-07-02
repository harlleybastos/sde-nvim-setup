-- ~/.config/nvim/lua/user/treesitter.lua
-- NOTE: this uses the classic `master`-branch API of nvim-treesitter.
-- The plugin is pinned to branch = "master" in plugins.lua (the `main`
-- branch is an incompatible rewrite that needs Neovim 0.12 nightly).
local configs = require("nvim-treesitter.configs")
configs.setup({
  ensure_installed = {
    -- Core languages
    "javascript", "typescript", "tsx",
    "ruby",
    "c", "cpp",
    "c_sharp",
    "go", "gomod", "gosum",

    -- Frontend
    "html", "css", "scss",
    "json",   -- jsonc is aliased to json below (its own grammar is broken upstream)

    -- Backend / Data
    "prisma",
    "sql",
    "graphql",

    -- DevOps
    "dockerfile",
    "hcl", "terraform",
    "yaml", "toml",

    -- General / Editor
    "vim", "vimdoc", "lua",
    "markdown", "markdown_inline",
    "regex", "bash", "jsdoc",
    "git_config", "gitignore",
  },

  sync_install  = false,
  auto_install  = true,
  highlight     = { enable = true },
  indent        = { enable = true },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection    = "<CR>",   -- start selecting the node under the cursor
      node_incremental  = "<CR>",   -- press again to grow the selection
      node_decremental  = "<BS>",   -- shrink the selection
      -- scope_incremental intentionally left unmapped: <TAB> is used for
      -- buffer switching (see keymaps.lua) and cmp completion (see lsp.lua).
      scope_incremental = false,
    },
  },

  textobjects = {
    select = {
      enable    = true,
      lookahead = true,
      keymaps   = {
        ["af"] = { query = "@function.outer",    desc = "Select outer function" },
        ["if"] = { query = "@function.inner",    desc = "Select inner function" },
        ["ac"] = { query = "@class.outer",       desc = "Select outer class" },
        ["ic"] = { query = "@class.inner",       desc = "Select inner class" },
        ["aa"] = { query = "@parameter.outer",   desc = "Select outer parameter" },
        ["ia"] = { query = "@parameter.inner",   desc = "Select inner parameter" },
        ["ai"] = { query = "@conditional.outer", desc = "Select outer conditional" },
        ["ii"] = { query = "@conditional.inner", desc = "Select inner conditional" },
        ["al"] = { query = "@loop.outer",        desc = "Select outer loop" },
        ["il"] = { query = "@loop.inner",        desc = "Select inner loop" },
      },
    },
    move = {
      enable    = true,
      set_jumps = true,
      goto_next_start     = {
        ["]m"] = { query = "@function.outer", desc = "Next function" },
        ["]c"] = { query = "@class.outer",    desc = "Next class" },
      },
      goto_previous_start = {
        ["[m"] = { query = "@function.outer", desc = "Previous function" },
        ["[c"] = { query = "@class.outer",    desc = "Previous class" },
      },
    },
    swap = {
      enable = true,
      swap_next     = { ["<leader>sn"] = "@parameter.inner" },
      swap_previous = { ["<leader>sp"] = "@parameter.inner" },
    },
  },
})

-- jsonc files (tsconfig.json, .vscode/*.json, etc.) reuse the `json` parser.
-- The dedicated jsonc grammar tarball is currently broken upstream, so we
-- alias the filetype instead of installing a separate parser.
pcall(vim.treesitter.language.register, "json", "jsonc")
