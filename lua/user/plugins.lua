-- ~/.config/nvim/lua/user/plugins.lua
-- Plugin manager: lazy.nvim (modern replacement for packer)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ── Theme: Dracula PRO ─────────────────────────────────
  -- Dracula PRO is a premium theme (https://draculatheme.com/pro)
  -- After purchasing, place the vim theme folder at:
  --   ~/.config/nvim/theme/dracula_pro/
  -- Falls back to free Dracula if PRO is not installed.
  {
    dir = vim.fn.stdpath("config") .. "/theme/dracula_pro",
    name = "dracula_pro",
    lazy = false,
    priority = 1000,
    config = function()
      -- Try Dracula PRO first; if not found, use free Dracula
      local ok = pcall(vim.cmd, "colorscheme dracula_pro")
      if not ok then
        -- PRO not installed yet — load free Dracula as fallback
        pcall(vim.cmd, "colorscheme dracula")
      end
    end,
  },
  -- Free Dracula as fallback (only loaded when PRO is missing)
  {
    "dracula/vim",
    name = "dracula",
    lazy = true,
    priority = 999,
  },

  -- ── Neovim + Tmux seamless navigation ──────────────────
  -- Ctrl-h/j/k/l moves between Neovim splits AND Tmux panes
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- ── Harpoon (ThePrimeagen) — instant file switching ───
  -- <leader>a  = mark file
  -- <leader>h  = open harpoon menu
  -- <leader>1-5 = jump to marked file
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end,
        { desc = "Harpoon: mark file" })
      vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "Harpoon: quick menu" })

      for i = 1, 5 do
        vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end,
          { desc = "Harpoon: file " .. i })
      end
    end,
  },

  -- ── Flash.nvim — jump anywhere on screen ───────────────
  -- s + 2 chars = jump to any visible text
  -- S = treesitter-aware selection (functions, blocks, etc.)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash: jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash: treesitter select" },
    },
  },

  -- ── Telescope — fuzzy finder ───────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })
      -- Load fzf extension for faster sorting
      pcall(telescope.load_extension, "fzf")
    end,
  },

  -- ── Treesitter — syntax highlighting & textobjects ─────
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("user.treesitter")
    end,
  },

  -- ── LSP + Completion ───────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("user.lsp")
    end,
  },
  -- SchemaStore: autocomplete schemas for JSON (package.json, tsconfig)
  -- and YAML (docker-compose, GitHub Actions, k8s manifests)
  { "b0o/schemastore.nvim", lazy = true },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },

  -- ── File explorer ──────────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 35 },
        filters = { dotfiles = false },
        git = { enable = true },
      })
    end,
  },

  -- ── Auto pairs & tags ─────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require("nvim-autopairs").setup({}) end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function() require("nvim-ts-autotag").setup({}) end,
  },

  -- ── Productivity ───────────────────────────────────────

  -- Comment: gcc (normal), gc (visual)
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function() require("Comment").setup() end,
  },

  -- Git signs in the gutter + inline blame
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = true,
      })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Use "dracula" lualine theme (works with both free & PRO)
      require("lualine").setup({
        options = {
          theme = "dracula",
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Which-key: shows available keybindings when you press <leader>
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({ delay = 300 })
      -- Register group labels so which-key shows clear categories
      wk.add({
        { "<leader>f",  group = "Find (Telescope)" },
        { "<leader>s",  group = "Split / Swap" },
        { "<leader>c",  group = "Code" },
        { "<leader>l",  group = "LSP" },
      })
    end,
  },

  -- Undotree: visual undo history (ThePrimeagen favorite)
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
    },
  },

  -- Surround: cs'" changes ' to ", ysiw" adds " around word
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function() require("nvim-surround").setup({}) end,
  },

}, {
  -- lazy.nvim options
  checker = { enabled = false },
  change_detection = { notify = false },
})
