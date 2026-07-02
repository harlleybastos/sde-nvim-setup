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
  {
	  "dracula/vim",
	  name = "dracula",
	  lazy = false,
	  priority = 1000,
	  config = function()
		  vim.cmd("colorscheme dracula")

		  -- Override com as cores exatas do Dracula Pro
		  vim.api.nvim_set_hl(0, "Normal",       { bg = "#22212C", fg = "#F8F8F2" })
		  vim.api.nvim_set_hl(0, "NormalFloat",  { bg = "#22212C" })
		  vim.api.nvim_set_hl(0, "Comment",      { fg = "#8B82C4", italic = true })
		  vim.api.nvim_set_hl(0, "String",       { fg = "#66F859" })
		  vim.api.nvim_set_hl(0, "Function",     { fg = "#7359F8" })
		  vim.api.nvim_set_hl(0, "Keyword",      { fg = "#F859A8" })
		  vim.api.nvim_set_hl(0, "Constant",     { fg = "#F8F859" })
		  vim.api.nvim_set_hl(0, "Type",         { fg = "#5CF5DB" })
		  vim.api.nvim_set_hl(0, "Number",       { fg = "#F87359" })
		  vim.api.nvim_set_hl(0, "Identifier",   { fg = "#F8F8F2" })
		  vim.api.nvim_set_hl(0, "Visual",       { bg = "#7359F8" })
		  vim.api.nvim_set_hl(0, "CursorLine",   { bg = "#2D2B3D" })
		  vim.api.nvim_set_hl(0, "LineNr",       { fg = "#8B82C4" })
		  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#F8F8F2", bold = true })
	  end,
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
      -- `s` is bound in normal + operator-pending only, so visual-mode `s`
      -- (substitute) keeps working as beginners expect.
      { "s", mode = { "n", "o" },      function() require("flash").jump() end,       desc = "Flash: jump" },
      { "S", mode = { "n", "o" },      function() require("flash").treesitter() end, desc = "Flash: treesitter select" },
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
  -- Pinned to the `master` branch: it is stable, backward-compatible, and
  -- matches the module API used in user/treesitter.lua. The `main` branch is
  -- an incompatible rewrite that requires Neovim 0.12 nightly.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
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
        filesystem_watchers = {
          enable = false,
        },
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
        { "<leader>b",  group = "Buffers / tabs" },
        { "<leader>t",  group = "Terminal / git" },
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

  -- ── Bufferline — visible editor tabs (VS Code tab bar) ──
  -- Open files show as tabs at the top. Cycle with <Tab>/<S-Tab>.
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          mode                   = "buffers",
          diagnostics            = "nvim_lsp",   -- show LSP errors on each tab
          show_buffer_close_icons = true,
          show_close_icon        = false,
          separator_style        = "thin",
          offsets = {
            { filetype = "NvimTree", text = "Explorer", highlight = "Directory", separator = true },
          },
        },
      })
      vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<CR>",        { desc = "Pick a buffer/tab" })
      vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
    end,
  },

  -- ── conform.nvim — format on save (like Prettier in VS Code) ──
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = { "ConformInfo" },
    config = function()
      local conform = require("conform")
      -- Prettier for web files, falling back from the daemon to the CLI.
      local prettier = { "prettierd", "prettier", stop_after_first = true }
      conform.setup({
        formatters_by_ft = {
          javascript     = prettier,
          javascriptreact = prettier,
          typescript     = prettier,
          typescriptreact = prettier,
          json           = prettier,
          jsonc          = prettier,
          css            = prettier,
          scss           = prettier,
          html           = prettier,
          yaml           = prettier,
          markdown       = prettier,
          graphql        = prettier,
          lua            = { "stylua" },
          go             = { "gofmt" },
        },
        -- Auto-format on save; fall back to the LSP formatter when no
        -- dedicated formatter is installed for a filetype.
        format_on_save = {
          timeout_ms = 1000,
          lsp_format = "fallback",
        },
      })
      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        conform.format({ async = true, lsp_format = "fallback" })
      end, { desc = "Format file / selection" })
    end,
  },

  -- ── toggleterm — integrated terminal (like VS Code's Ctrl+`) ──
  -- <C-\> toggles a floating terminal without leaving Neovim.
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        direction    = "float",
        float_opts   = { border = "curved" },
      })

      local Terminal = require("toggleterm.terminal").Terminal

      local horiz = Terminal:new({ direction = "horizontal", hidden = true })
      vim.keymap.set("n", "<leader>tt", function() horiz:toggle() end,
        { desc = "Terminal (horizontal split)" })

      -- Lazygit in a fullscreen float. Needs the `lazygit` binary installed;
      -- if it's missing the terminal just shows a 'command not found' message.
      local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
      vim.keymap.set("n", "<leader>tg", function() lazygit:toggle() end,
        { desc = "Lazygit (git TUI)" })
    end,
  },

  -- ── indent-blankline — indent guides (like VS Code) ──
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope  = { enabled = true, show_start = false, show_end = false },
      })
    end,
  },

  -- ── nvim-navic — code breadcrumbs in the winbar (VS Code breadcrumbs) ──
  -- Attaches to the LSP in lua/user/lsp.lua (see the LspAttach autocmd).
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function() vim.g.navic_silence = true end,
    config = function()
      require("nvim-navic").setup({ highlight = true })
    end,
  },

  -- ── hardtime.nvim — Vim-motion trainer (breaks VS Code habits) ──
  -- Nudges you toward efficient motions instead of spamming j/k/arrows.
  -- Toggle it off any time with <leader>H.
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "VeryLazy",
    config = function()
      require("hardtime").setup({
        restriction_mode = "hint",   -- hint (gentle), not block — beginner friendly
        disable_mouse    = false,    -- keep the mouse usable while you learn
      })
      vim.keymap.set("n", "<leader>H", "<cmd>Hardtime toggle<CR>",
        { desc = "Toggle Hardtime (Vim trainer)" })
    end,
  },

}, {
  -- lazy.nvim options
  checker = { enabled = false },
  change_detection = { notify = false },
})
