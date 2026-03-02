-- ~/.config/nvim/lua/user/treesitter.lua
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    -- Core languages
    "javascript", "typescript", "tsx",
    "ruby",
    "c", "cpp",
    "c_sharp",
    "go", "gomod", "gosum",

    -- Frontend
    "html", "css", "scss",
    "json", "jsonc",

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
  auto_install  = true,  -- Auto-install parsers when opening a file

  highlight = { enable = true },
  indent    = { enable = true },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection    = "<CR>",
      node_incremental  = "<CR>",
      node_decremental  = "<BS>",
      scope_incremental = "<TAB>",
    },
  },

  -- ── Textobjects — navigate & select code structures ────
  -- vaf = select entire function      vif = select function body
  -- vac = select entire class         daf = delete whole function
  -- ]m  = next function               [m  = previous function
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
      swap_next     = { ["<leader>sn"] = "@parameter.inner" },  -- Swap param forward
      swap_previous = { ["<leader>sp"] = "@parameter.inner" },  -- Swap param backward
    },
  },
})
