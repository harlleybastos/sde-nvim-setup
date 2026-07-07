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
        view = { width = 25 },       -- default width of the tree (change this number)
        renderer = {
          -- Show just the folder name (e.g. "gaming") instead of the full
          -- "~/Projects/Study/gaming/.." path. Use false to hide it entirely.
          root_folder_label = ":t",
        },
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
      local gs = require("gitsigns")
      gs.setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = true,
        on_attach = function(buf)
          local function map(l, r, d) vim.keymap.set("n", l, r, { buffer = buf, desc = d }) end
          -- Visual git (like VS Code's Source Control): stage/reset/preview hunks
          map("]h", function() gs.nav_hunk("next") end, "Next hunk (git change)")
          map("[h", function() gs.nav_hunk("prev") end, "Previous hunk")
          map("<leader>gs", gs.stage_hunk,       "Stage hunk")
          map("<leader>gr", gs.reset_hunk,       "Reset hunk")
          map("<leader>gS", gs.stage_buffer,     "Stage whole file")
          map("<leader>gu", gs.undo_stage_hunk,  "Undo stage hunk")
          map("<leader>gp", gs.preview_hunk,     "Preview hunk (inline diff)")
          map("<leader>gb", function() gs.blame_line({ full = true }) end, "Blame this line")
          map("<leader>gd", gs.diffthis,         "Diff this file")
        end,
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
        { "<leader>t",  group = "Terminal" },
        { "<leader>d",  group = "Debug (DAP)" },
        { "<leader>C",  group = "CMake (build/run/debug)" },
        { "<leader>g",  group = "Git (hunks / diff)" },
        { "<leader>x",  group = "Problems / diagnostics" },
        { "<leader>T",  group = "Tests (neotest)" },
        { "<leader>m",  group = "Markdown" },
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
    -- Defined here (not in config) so <leader>cf works even before the first
    -- save — lazy creates the mapping and loads conform on demand.
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "x" },
        desc = "Format file / selection",
      },
    },
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
          c              = { "clang-format" },
          cpp            = { "clang-format" },
        },
        -- Auto-format on save; fall back to the LSP formatter when no
        -- dedicated formatter is installed for a filetype.
        format_on_save = {
          timeout_ms = 1000,
          lsp_format = "fallback",
        },
      })
    end,
  },

  -- ── grug-far — visual search & replace across the project ──
  -- A panel with live preview of every change (like VS Code's Search/Replace).
  -- Needs ripgrep (already installed). <leader>S opens it prefilled with the
  -- word under the cursor; in visual mode it searches the selection.
  {
    "MagicDuck/grug-far.nvim",
    cmd  = "GrugFar",
    opts = {},
    keys = {
      {
        "<leader>S",
        function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end,
        mode = "n",
        desc = "Search & Replace in project (word under cursor)",
      },
      {
        "<leader>S",
        function() require("grug-far").with_visual_selection() end,
        mode = "x",
        desc = "Search & Replace in project (selection)",
      },
    },
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
        restriction_mode = "hint",   -- hint (teaches), not block — beginner friendly
        disable_mouse    = false,    -- keep the mouse usable while you learn
        hint             = true,     -- suggest a better motion inline
        notification     = true,     -- pop the "you pressed j too many times" nudges
        max_count        = 4,        -- allow up to 4 repeats before nudging
      })
      vim.keymap.set("n", "<leader>H", "<cmd>Hardtime toggle<CR>",
        { desc = "Toggle Hardtime (Vim trainer)" })
    end,
  },

  -- ── precognition — live motion hints next to the cursor (learn motions) ──
  -- Shows which keys (w b e ^ $ f …) get you where you're looking. Off by
  -- default so it's not noisy; turn it on to drill motions: :Precognition
  -- (or :Precognition toggle / on / off).
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    cmd   = "Precognition",       -- ensure :Precognition is always available
    opts  = { startVisible = false },
  },

  -- ══════════════════════════════════════════════════════════
  -- C / C++ / GAME-ENGINE (OpenGL, Vulkan) TOOLING
  -- ══════════════════════════════════════════════════════════

  -- Auto-install non-LSP tools (formatters/etc.) via Mason
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = { "clang-format" },  -- C/C++ formatter for conform
        run_on_start = true,
      })
    end,
  },

  -- ── Debugging (DAP) — breakpoints, stepping, watches (like VS Code F5) ──
  -- codelldb debugs C/C++ (and Rust). :CMakeDebug wires this up for CMake projects.
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",   -- Python (debugpy)
      "leoluz/nvim-dap-go",             -- Go (delve)
      "suketa/nvim-dap-ruby",           -- Ruby (rdbg / debug gem)
    },
    keys = {
      { "<F5>",  function() require("dap").continue() end,   desc = "Debug: start / continue" },
      { "<F10>", function() require("dap").step_over() end,  desc = "Debug: step over" },
      { "<F11>", function() require("dap").step_into() end,  desc = "Debug: step into" },
      { "<leader>dc", function() require("dap").continue() end,          desc = "Continue / start" },
      { "<leader>do", function() require("dap").step_out() end,          desc = "Step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>dr", function() require("dap").repl.toggle() end,       desc = "Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end,          desc = "Run last" },
      { "<leader>dt", function() require("dap").terminate() end,         desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end,          desc = "Toggle debug UI" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Evaluate expression" },
    },
    config = function()
      local dap   = require("dap")
      local dapui = require("dapui")

      -- Auto-install debug adapters and wire them (default handler configures
      -- codelldb=C/C++/Rust, js=JS/TS, netcoredbg=C#; python/go/ruby set up below).
      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb", "python", "delve", "js", "netcoredbg" },
        automatic_installation = true,
        handlers = {
          function(config) require("mason-nvim-dap").default_setup(config) end,
        },
      })

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      -- Language-specific helpers (richer than the generic defaults)
      local mason_pkgs = vim.fn.stdpath("data") .. "/mason/packages"
      pcall(function() require("dap-python").setup(mason_pkgs .. "/debugpy/venv/bin/python") end)
      pcall(function() require("dap-go").setup() end)
      pcall(function() require("dap-ruby").setup() end)

      -- C / C++ launch config (prompts for the built executable)
      local launch = {
        {
          name    = "Launch (pick executable)",
          type    = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name    = "Attach to process",
          type    = "codelldb",
          request = "attach",
          pid     = require("dap.utils").pick_process,
          cwd     = "${workspaceFolder}",
        },
      }
      dap.configurations.cpp  = launch
      dap.configurations.c    = launch
      dap.configurations.rust = launch   -- codelldb debugs Rust too

      -- Nicer breakpoint / stopped signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapStopped",    { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual" })

      -- Open/close the debug UI automatically
      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
    end,
  },

  -- ── CMake integration — configure / build / run / debug from Neovim ──
  -- Generates compile_commands.json (clangd reads it) and drives :CMakeDebug via DAP.
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft  = { "c", "cpp", "cmake", "objc", "objcpp" },
    cmd = {
      "CMakeGenerate", "CMakeBuild", "CMakeRun", "CMakeDebug",
      "CMakeSelectBuildTarget", "CMakeSelectLaunchTarget",
      "CMakeSelectBuildType", "CMakeClean",
    },
    keys = {
      { "<F7>",       "<cmd>CMakeBuild<CR>",              desc = "CMake: build" },
      { "<leader>Cg", "<cmd>CMakeGenerate<CR>",           desc = "CMake: generate / configure" },
      { "<leader>Cb", "<cmd>CMakeBuild<CR>",              desc = "CMake: build" },
      { "<leader>Cr", "<cmd>CMakeRun<CR>",                desc = "CMake: run" },
      { "<leader>Cd", "<cmd>CMakeDebug<CR>",              desc = "CMake: debug (DAP)" },
      { "<leader>Ct", "<cmd>CMakeSelectBuildType<CR>",    desc = "CMake: select build type" },
      { "<leader>CT", "<cmd>CMakeSelectBuildTarget<CR>",  desc = "CMake: select build target" },
      { "<leader>Cl", "<cmd>CMakeSelectLaunchTarget<CR>", desc = "CMake: select launch target" },
      { "<leader>Cc", "<cmd>CMakeClean<CR>",              desc = "CMake: clean" },
    },
    opts = {
      cmake_command                    = "cmake",
      cmake_build_directory            = "build",
      cmake_generate_options           = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
      cmake_soft_link_compile_commands = true,   -- symlink compile_commands.json to project root
      dap_configuration = {
        type          = "codelldb",
        request       = "launch",
        stopOnEntry   = false,
        runInTerminal = false,
      },
    },
  },

  -- ── clangd extensions — inlay hints, AST, type hierarchy for C++ ──
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda" },
    opts = {
      inlay_hints = { inline = true },
      ast = { role_icons = {}, kind_icons = {} },
    },
  },

  -- ══════════════════════════════════════════════════════════
  -- VS CODE PARITY PACK
  -- ══════════════════════════════════════════════════════════

  -- ── persistence — reopen the project where you left off ──
  -- Auto-restores the session when you open `nvim` with no file in a folder
  -- you've worked in before (like VS Code reopening your workspace).
  {
    "folke/persistence.nvim",
    lazy = false,
    config = function()
      require("persistence").setup()
      vim.api.nvim_create_autocmd("VimEnter", {
        nested = true,
        callback = function()
          local ft = vim.bo.filetype
          if vim.fn.argc() == 0 and ft ~= "gitcommit" and ft ~= "gitrebase" then
            require("persistence").load()
          end
        end,
      })
      vim.api.nvim_create_user_command("SessionRestore",
        function() require("persistence").load() end, { desc = "Restore session for this folder" })
      vim.api.nvim_create_user_command("SessionRestoreLast",
        function() require("persistence").load({ last = true }) end, { desc = "Restore the last session" })
    end,
  },

  -- ── diffview — side-by-side diffs & merge (VS Code diff editor) ──
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    opts = {},
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen<CR>",          desc = "Git: diff view (working tree)" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Git: file history (this file)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>",   desc = "Git: repo/branch history" },
    },
  },

  -- ── vim-visual-multi — true multi-cursor (VS Code Ctrl+D) ──
  -- <C-n> selects the word + next occurrence · <C-Down>/<C-Up> add cursors.
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event  = "VeryLazy",
  },

  -- ── markdown-preview — live preview in the browser ──
  {
    "iamcco/markdown-preview.nvim",
    ft    = "markdown",
    build = function() vim.fn["mkdp#util#install"]() end,
    keys  = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown preview (browser)" },
    },
    config = function()
      -- On WSL, open in the Windows browser via wslview if it's installed
      -- (sudo dnf install wslu). Otherwise mkdp prints a URL you can open.
      if vim.fn.has("wsl") == 1 and vim.fn.executable("wslview") == 1 then
        vim.g.mkdp_browser = "wslview"
      end
    end,
  },

  -- ── trouble — persistent Problems / diagnostics panel ──
  {
    "folke/trouble.nvim",
    cmd  = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",              desc = "Problems: all diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Problems: this file only" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                   desc = "Quickfix list" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>",                  desc = "Location list" },
    },
  },

  -- ── aerial — Outline panel (symbol tree sidebar) ──
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    cmd  = "AerialToggle",
    opts = {},
    keys = {
      { "<leader>o", "<cmd>AerialToggle!<CR>", desc = "Outline (symbols sidebar)" },
    },
  },

  -- ── neotest — Test Explorer (run/debug tests, see pass/fail) ──
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",     -- Python (pytest/unittest)
      "fredrikaverpil/neotest-golang",   -- Go
      "nvim-neotest/neotest-jest",       -- JS / TS (jest)
      "olimorris/neotest-rspec",         -- Ruby (rspec)
    },
    keys = {
      { "<leader>Tt", function() require("neotest").run.run() end,                     desc = "Test: run nearest" },
      { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Test: run file" },
      { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: debug nearest" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end,              desc = "Test: summary panel" },
      { "<leader>To", function() require("neotest").output.open({ enter = true }) end, desc = "Test: show output" },
      { "<leader>TS", function() require("neotest").run.stop() end,                    desc = "Test: stop" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python"),
          require("neotest-golang"),
          require("neotest-jest"),
          require("neotest-rspec"),
        },
      })
    end,
  },

}, {
  -- lazy.nvim options
  checker = { enabled = false },
  change_detection = { notify = false },
})
