# Neovim + Tmux — Professional Navigation Setup

A professional Neovim + Tmux configuration for fast, keyboard-driven development. Inspired by ThePrimeagen and tj-devries. Optimized for web development (TypeScript/JavaScript) on **Rocky Linux 10 WSL2** and **Arch Linux**.

Uses the **Dracula PRO** color scheme (with free Dracula as automatic fallback).

---

## Installation

### Prerequisites

<details>
<summary><strong>Rocky Linux 10 (WSL2 or bare metal)</strong></summary>

```bash
# Core tools
sudo dnf install -y neovim tmux git gcc make unzip curl

# Search tools (used by Telescope)
sudo dnf install -y ripgrep fd-find fzf

# Node.js (required for JS/TS LSP servers)
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
sudo dnf install -y nodejs

# Nerd Font (required for icons)
# Install a Nerd Font on your Windows host (e.g. JetBrainsMono Nerd Font)
# and set it as the terminal font in Windows Terminal / your terminal emulator.
```
</details>

<details>
<summary><strong>Arch Linux</strong></summary>

```bash
# Core tools
sudo pacman -S --noconfirm neovim tmux git gcc make unzip curl

# Search tools (used by Telescope)
sudo pacman -S --noconfirm ripgrep fd fzf

# Node.js (required for JS/TS LSP servers)
sudo pacman -S --noconfirm nodejs npm

# Clipboard support
sudo pacman -S --noconfirm wl-clipboard   # Wayland
# Or: sudo pacman -S --noconfirm xclip    # X11

# Nerd Font
sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd
```
</details>

### Deploy the configs

```bash
# Neovim config
mkdir -p ~/.config/nvim
cp -r init.lua lua/ ~/.config/nvim/

# Tmux config
cp .tmux.conf ~/

# Open Neovim — lazy.nvim bootstraps and installs everything automatically
nvim

# Reload tmux (if tmux is already running)
tmux source-file ~/.tmux.conf
```

### Install Dracula PRO theme (optional)

1. Purchase [Dracula PRO](https://draculatheme.com/pro)
2. Download the Vim theme from the Dracula PRO dashboard
3. Place the theme files so the colorscheme file exists at:
   ```
   ~/.config/nvim/theme/dracula_pro/colors/dracula_pro.vim
   ```
4. Restart Neovim — it will automatically use Dracula PRO

> **Note:** If Dracula PRO is not installed, the free [Dracula](https://github.com/dracula/vim) theme is used as an automatic fallback. Everything works either way.

### First launch

When you open Neovim for the first time, `lazy.nvim` will:
1. Bootstrap itself
2. Install all plugins
3. Install Treesitter parsers
4. Mason will install LSP servers: `ts_ls`, `html`, `cssls`, `eslint`, `lua_ls`

---

## Don't know how to do something? Press `<Space>?`

This setup includes a **searchable interactive cheatsheet** built into Neovim.

Press **`<leader>?`** (Space + ?) and type what you *want to do* in plain English:

```
┌─ Navigation Cheatsheet — type what you want to do ──────┐
│ > jump function                                          │
│   ]m / [m           │ Next / previous function           │
│   vaf               │ Select entire function             │
│   daf               │ Delete entire function             │
│   gd                │ Go to definition                   │
└──────────────────────────────────────────────────────────┘
```

You can also:
- Press **`<Space>`** and wait 300ms → **which-key** shows all available keybindings
- Press **`<Space>fk`** → search ALL keymaps via Telescope
- Press **`<Space>fh`** → search Neovim help tags

---

## How the setup works

```
┌─────────────────────────────────────────────────────────────┐
│ TMUX (manages sessions, windows, and panes)                 │
│  ┌────────────────────┐  ┌────────────────────────────────┐ │
│  │ Neovim             │  │ Terminal                       │ │
│  │  ┌──────┬────────┐ │  │                                │ │
│  │  │      │        │ │  │  $ npm run dev                 │ │
│  │  │ Code │ Code   │ │  │  $ git log --oneline          │ │
│  │  │      │        │ │  │                                │ │
│  │  └──────┴────────┘ │  │                                │ │
│  └────────────────────┘  └────────────────────────────────┘ │
│         Ctrl-h/j/k/l moves across EVERYTHING seamlessly     │
└─────────────────────────────────────────────────────────────┘
```

**vim-tmux-navigator** makes `Ctrl-h/j/k/l` work across Neovim splits AND Tmux panes as if they were one thing. No context switching.

---

## Quick Reference

### Tmux (Prefix = `Ctrl-a`)

| Shortcut | Action |
|----------|--------|
| `C-a \|` | Vertical split |
| `C-a -` | Horizontal split |
| `C-h/j/k/l` | Navigate panes (works with Neovim!) |
| `Alt-h/j/k/l` | Resize pane |
| `C-a c` | New window |
| `Alt-1..5` | Switch to window 1-5 |
| `C-a f` | **Sessionizer** — switch project via fzf |
| `C-a [` | Copy mode (vi keys) |
| `C-a r` | Reload tmux config |

### File navigation

| Shortcut | Plugin | Action |
|----------|--------|--------|
| `<Space>ff` | Telescope | Find file by name |
| `<C-p>` | Telescope | Find file (alternative) |
| `<Space>fg` | Telescope | Grep text across all files |
| `<Space>fb` | Telescope | Switch between open buffers |
| `<Space>fr` | Telescope | Recently opened files |
| `<Space>fw` | Telescope | Grep word under cursor |
| `<Space>e` | NvimTree | Toggle file explorer |

### Harpoon — instant file switching

Mark the 3-5 files you're working on, then jump between them instantly:

| Shortcut | Action |
|----------|--------|
| `<Space>a` | **Mark** current file |
| `<Space>h` | Open Harpoon menu |
| `<Space>1..5` | Jump to marked file 1-5 |

### Flash — jump anywhere on screen

| Shortcut | Action |
|----------|--------|
| `s` + 2 chars | Jump to any visible text |
| `S` | Treesitter-aware selection |

### In-file movement

| Shortcut | Action |
|----------|--------|
| `<C-d>` / `<C-u>` | Half-page down/up (centered) |
| `{` / `}` | Previous / next paragraph |
| `gg` / `G` | Start / end of file |
| `5j` / `10k` | Jump N lines (use relative numbers!) |
| `f{char}` | Jump to char on current line |
| `%` | Jump to matching bracket |
| `*` / `#` | Search word under cursor (next / prev) |

### LSP — code intelligence

| Shortcut | Action |
|----------|--------|
| `gd` | Go to **definition** |
| `gD` | Go to **declaration** |
| `gr` | Show **references** |
| `gi` | Go to **implementation** |
| `K` | Hover documentation |
| `<Space>ca` | Code action (fix, refactor) |
| `<Space>rn` | Rename symbol (across files!) |
| `<Space>ld` | Line diagnostics |
| `[d` / `]d` | Previous / next diagnostic |

### Treesitter textobjects

| Shortcut | Action |
|----------|--------|
| `vaf` / `vif` | Select function (outer / inner) |
| `vac` / `vic` | Select class (outer / inner) |
| `vaa` / `via` | Select parameter (outer / inner) |
| `daf` | Delete entire function |
| `cif` | Change function body |
| `]m` / `[m` | Next / previous function |
| `]c` / `[c` | Next / previous class |
| `<Space>sn` / `<Space>sp` | Swap parameter forward / backward |

### Editing

| Shortcut | Action |
|----------|--------|
| `gcc` | Toggle comment (line) |
| `gc` (visual) | Toggle comment (selection) |
| `cs'"` | Change surrounding `'` to `"` |
| `ysiw"` | Add `"` around word |
| `ds"` | Remove surrounding `"` |
| `J` / `K` (visual) | Move lines up / down |
| `<Space>p` (visual) | Paste without losing register |
| `<Space>y` | Yank to system clipboard |
| `<Space>u` | Toggle Undotree |
| `<` / `>` (visual) | Indent keeping selection |

### Buffers & windows

| Shortcut | Action |
|----------|--------|
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<Space>x` | Close buffer |
| `<Space>sv` / `<Space>sh` | Vertical / horizontal split |
| `<C-h/j/k/l>` | Move between splits & Tmux panes |
| `<C-arrows>` | Resize split |

### General

| Shortcut | Action |
|----------|--------|
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Esc>` | Clear search highlight |
| `<Space>?` | **Open interactive cheatsheet** |
| `<Space>fk` | Search all keymaps |
| `<Space>fh` | Search help tags |

---

## Project structure

```
├── init.lua                # Entry point — loads all modules
├── .tmux.conf              # Tmux config (copy to ~/.tmux.conf)
├── README.md
└── lua/
    └── user/
        ├── options.lua     # Vim options (UI, search, clipboard…)
        ├── keymaps.lua     # All keybindings
        ├── plugins.lua     # lazy.nvim bootstrap + plugin specs
        ├── treesitter.lua  # Syntax highlighting + textobjects
        ├── lsp.lua         # LSP servers + autocompletion
        └── cheatsheet.lua  # Interactive searchable cheatsheet
```

## Plugins

| Plugin | Purpose |
|--------|---------|
| **lazy.nvim** | Plugin manager |
| **Dracula PRO** / **dracula** | Color scheme (PRO with free fallback) |
| **vim-tmux-navigator** | Seamless Neovim ↔ Tmux navigation |
| **harpoon** | Instant file switching (mark & jump) |
| **flash.nvim** | Jump to any text on screen |
| **telescope.nvim** | Fuzzy finder (files, grep, buffers, keymaps) |
| **telescope-fzf-native** | Faster sorting algorithm for Telescope |
| **nvim-treesitter** | Smart syntax highlighting |
| **treesitter-textobjects** | Select/navigate functions, classes, params |
| **nvim-lspconfig** | LSP server configuration |
| **mason.nvim** | Automatic LSP server installer |
| **nvim-cmp** | Autocompletion engine |
| **LuaSnip** + **friendly-snippets** | Snippet engine + collection |
| **nvim-tree** | File explorer sidebar |
| **nvim-autopairs** | Auto-close brackets |
| **nvim-ts-autotag** | Auto-close HTML/JSX tags |
| **Comment.nvim** | Toggle comments with `gcc` / `gc` |
| **gitsigns.nvim** | Git diff signs + inline blame |
| **lualine.nvim** | Status bar |
| **which-key.nvim** | Shows available keybindings on `<Space>` |
| **undotree** | Visual undo history |
| **nvim-surround** | Manipulate surrounding chars/tags |

