-- ~/.config/nvim/lua/user/options.lua
local opt = vim.opt

-- ── UI ───────────────────────────────────────────────────
opt.number         = true           -- Show line numbers
opt.relativenumber = true           -- Relative numbers (essential for fast jumps like 5j, 12k)
opt.signcolumn     = "yes"          -- Always show sign column (git signs, diagnostics)
opt.cursorline     = true           -- Highlight current line
opt.termguicolors  = true           -- 24-bit RGB colors
opt.colorcolumn    = "80"           -- Ruler at column 80
opt.showmode       = false          -- Lualine already shows the mode

-- ── Indentation ──────────────────────────────────────────
opt.expandtab   = true              -- Use spaces instead of tabs
opt.shiftwidth  = 2                 -- Indent by 2 spaces
opt.tabstop     = 2                 -- Tab equals 2 spaces
opt.smartindent = true              -- Smart auto-indentation
opt.breakindent = true              -- Preserve indentation on wrapped lines

-- ── Search ───────────────────────────────────────────────
opt.ignorecase = true               -- Case-insensitive search
opt.smartcase  = true               -- Case-sensitive when uppercase is used
opt.hlsearch   = true               -- Highlight search results
opt.incsearch  = true               -- Incremental search (show matches while typing)

-- ── Navigation & scroll ─────────────────────────────────
opt.scrolloff     = 8               -- Keep 8 lines visible above/below cursor
opt.sidescrolloff = 8               -- Keep 8 columns visible on sides
opt.wrap          = false           -- Don't wrap long lines

-- ── Files & backup ──────────────────────────────────────
opt.swapfile = false                -- No swap files
opt.backup   = false                -- No backup files
opt.undofile = true                 -- Persistent undo (works with undotree!)
opt.undodir  = vim.fn.stdpath("data") .. "/undodir"

-- ── Splits ───────────────────────────────────────────────
opt.splitbelow = true               -- Horizontal splits open below
opt.splitright = true               -- Vertical splits open to the right

-- ── Clipboard ────────────────────────────────────────────
-- Works on WSL2 (clip.exe), Wayland (wl-copy), X11 (xclip)
opt.clipboard = "unnamedplus"

-- ── Performance ──────────────────────────────────────────
opt.updatetime = 250                -- Faster CursorHold events (default is 4000ms)
opt.timeoutlen = 300                -- Time to complete a keymap sequence

-- ── Misc ─────────────────────────────────────────────────
opt.mouse       = "a"              -- Enable mouse (useful for pane resizing)
opt.completeopt = "menuone,noselect"
opt.isfname:append("@-@")

-- Disable netrw (nvim-tree replaces it)
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
