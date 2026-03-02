-- ~/.config/nvim/lua/user/keymaps.lua
-- Professional keybindings for fast navigation
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ── Leader key ───────────────────────────────────────────
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── Window navigation ────────────────────────────────────
-- Handled by vim-tmux-navigator: Ctrl-h/j/k/l moves between
-- Neovim splits AND Tmux panes seamlessly (no extra config needed)

-- ── Telescope (fuzzy finding) ────────────────────────────
keymap("n", "<leader>ff", ":Telescope find_files<CR>",            { desc = "Find files" })
keymap("n", "<leader>fg", ":Telescope live_grep<CR>",             { desc = "Live grep" })
keymap("n", "<leader>fb", ":Telescope buffers<CR>",               { desc = "Find buffers" })
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>",              { desc = "Recent files" })
keymap("n", "<leader>fd", ":Telescope diagnostics<CR>",           { desc = "Find diagnostics" })
keymap("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>",  { desc = "Find symbols" })
keymap("n", "<leader>fw", ":Telescope grep_string<CR>",           { desc = "Find word under cursor" })
keymap("n", "<leader>fk", ":Telescope keymaps<CR>",               { desc = "Find keymaps" })
keymap("n", "<leader>fh", ":Telescope help_tags<CR>",             { desc = "Find help" })
keymap("n", "<C-p>",      ":Telescope find_files<CR>",            { desc = "Find files (Ctrl-P)" })

-- ── File explorer ────────────────────────────────────────
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- ── LSP navigation ───────────────────────────────────────
keymap("n", "gd",         vim.lsp.buf.definition,      { desc = "Go to definition" })
keymap("n", "gD",         vim.lsp.buf.declaration,      { desc = "Go to declaration" })
keymap("n", "gr",         vim.lsp.buf.references,       { desc = "Show references" })
keymap("n", "gi",         vim.lsp.buf.implementation,   { desc = "Go to implementation" })
keymap("n", "K",          vim.lsp.buf.hover,            { desc = "Hover documentation" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action,      { desc = "Code action" })
keymap("n", "<leader>rn", vim.lsp.buf.rename,           { desc = "Rename symbol" })
keymap("n", "<leader>ld", vim.diagnostic.open_float,    { desc = "Line diagnostics" })
keymap("n", "[d",         vim.diagnostic.goto_prev,     { desc = "Previous diagnostic" })
keymap("n", "]d",         vim.diagnostic.goto_next,     { desc = "Next diagnostic" })

-- ── Buffers ──────────────────────────────────────────────
keymap("n", "<Tab>",   ":bnext<CR>",     { desc = "Next buffer" })
keymap("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })

-- ── Move lines in visual mode ────────────────────────────
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ── Editing improvements (ThePrimeagen style) ────────────

-- J keeps cursor in place when joining lines
keymap("n", "J", "mzJ`z", opts)

-- Ctrl-d/u keep cursor centered while scrolling
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Search results stay centered
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Paste over selection without losing register
keymap("x", "<leader>p", [["_dP]], { desc = "Paste without losing register" })

-- Yank to system clipboard
keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
keymap("n", "<leader>Y", [["+Y]],          { desc = "Yank line to clipboard" })

-- Delete without yanking
keymap({ "n", "v" }, "<leader>D", [["_d]], { desc = "Delete without yanking" })

-- Quick save / quit
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Clear search highlight
keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlight" })

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Keep visual selection after indent
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Quickfix navigation
keymap("n", "<leader>j", ":cnext<CR>zz", { desc = "Next quickfix" })
keymap("n", "<leader>k", ":cprev<CR>zz", { desc = "Previous quickfix" })

-- Splits
keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
keymap("n", "<leader>sh", ":split<CR>",  { desc = "Horizontal split" })

-- Resize splits with arrow keys
keymap("n", "<C-Up>",    ":resize +2<CR>",          opts)
keymap("n", "<C-Down>",  ":resize -2<CR>",          opts)
keymap("n", "<C-Left>",  ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- ── Cheatsheet (interactive help) ────────────────────────
-- Press <leader>? to open a searchable cheatsheet inside Neovim
keymap("n", "<leader>?", function() require("user.cheatsheet").open() end,
  { desc = "Navigation cheatsheet" })
