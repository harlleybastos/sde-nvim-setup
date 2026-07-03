# Neovim + Tmux — Professional Navigation Setup

A professional Neovim + Tmux configuration for fast, keyboard-driven development. Inspired by ThePrimeagen and tj-devries. Optimized for web development (TypeScript/JavaScript) on **Rocky Linux 10 WSL2** and **Arch Linux**.

Uses the **Dracula PRO** color scheme (with free Dracula as automatic fallback).

---

## Installation

> **Requires Neovim 0.11 or newer** (this config uses the modern `vim.lsp.config`
> LSP API). Check with `nvim --version`. If you're below 0.11, LSP + completion are
> disabled with a warning until you upgrade — the rest of the editor still works.
> On distros that ship an older Neovim (e.g. Rocky Linux's `dnf` package is 0.10.x),
> install the latest from the official prebuilt release instead:
>
> ```bash
> curl -fsSLo /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
> sudo tar -C /opt -xzf /tmp/nvim.tar.gz
> sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
> nvim --version   # confirm 0.11+
> ```

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
3. Install Treesitter parsers (`:TSUpdate` runs automatically)
4. Mason installs the configured LSP servers (this can take a few minutes)

**LSP servers installed by Mason** (`lua/user/lsp.lua`), by category:

- **JS / TS / web:** `ts_ls`, `html`, `cssls`, `tailwindcss`, `angularls`, `emmet_ls`, `eslint`, `biome`, `prismals`
- **Data / config:** `jsonls`, `yamlls`, `graphql` *(via Treesitter)*
- **Native / game:** `clangd` (C/C++), `cmake` (CMake), `glsl_analyzer` (shaders), `solargraph` (Ruby)
- **DevOps:** `dockerls`, `docker_compose_language_service`, `terraformls`
- **Editor:** `lua_ls`

> `gopls` (Go) and `omnisharp` (C#) are **not** installed by default (they need the
> Go / .NET toolchains). Add them back to the `ensure_installed` list in
> `lua/user/lsp.lua` once those toolchains are present.

### Optional productivity tools

These enable extra features but aren't required — the editor works without them:

- **Formatters** (for format-on-save via conform.nvim): `prettierd` or `prettier`
  (`npm i -g @fsouza/prettierd`), `stylua` (Lua), `gofmt` (ships with Go).
- **lazygit** (opened with `<leader>tg`): a fast full-screen git UI. Arch:
  `sudo pacman -S lazygit`. Others: see the lazygit install docs.

---

## Two built-in helpers (no external cheatsheet needed)

**`<Space>?` → the day-to-day guide.** A glanceable floating panel grouped by the
tasks you do all day, in learning order — your in-editor sticky note:

```
╭ Neovim · day-to-day ────────────────────────────────────╮
│  ▌ 3 · WINDOWS & SPLITS — move between panes             │
│      <C-h> / <C-l>   move to LEFT / RIGHT split          │
│  ▌ 6 · SEARCH — find files & text                        │
│      <Space>ff       find file by name        (Ctrl+P)   │
│  ▌ 7 · REPLACE — change & rename                         │
│      <Space>rn       rename symbol (semantic)     (F2)   │
╰──────────────────  q / <Esc> close  ────────────────────╯
```
12 sections: move · fast motions · windows · explorer · buffers · search ·
replace · edit · format · lint · build/debug · tmux.
Edit it in [`lua/user/quickref.lua`](lua/user/quickref.lua). Also on `:Guide`.

**`<F1>` → the searchable cheatsheet.** Type what you'd do in VS Code (e.g. "rename",
"find file", "comment") and it shows the Vim way. Also on `:Cheatsheet`.

You can also:
- Press **`<Space>`** and wait → **which-key** shows every leader binding
- **`<Space>fk`** → search ALL keymaps · **`<Space>fh`** → search Neovim help
- New to Vim? Start with **[LEARNING.md](LEARNING.md)** (plan + daily drills)

**Learn while you work (automatic):** a rotating pro **tip** shows on each startup
(`:Tip` for another); **hardtime** nudges you toward better motions when you mash a key
(`<Space>H` toggles); and **`:Precognition`** overlays the exact motion keys next to your
cursor for drilling. See [LEARNING.md](LEARNING.md#learn-while-you-work-automatic-feedback).

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

> **Sessionizer path:** `C-a f` searches `~/Projects` (see `.tmux.conf`). If your
> code lives elsewhere (e.g. `~/code`, `~/dev`), edit that path in `.tmux.conf`.

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
| `<Space>cf` | Format file / selection (also runs on save) |
| `<` / `>` (visual) | Indent keeping selection |

### Buffers & windows

| Shortcut | Action |
|----------|--------|
| `<Tab>` / `<S-Tab>` | Next / previous buffer (visible as tabs via bufferline) |
| `<Space>bp` | Pick a tab/buffer by letter |
| `<Space>bo` | Close all other buffers |
| `<Space>x` | Close buffer |
| `<Space>sv` / `<Space>sh` | Vertical / horizontal split |
| `<C-h/j/k/l>` | Move between splits & Tmux panes |
| `<C-arrows>` | Resize split |

### Terminal & Git (inside Neovim)

| Shortcut | Action |
|----------|--------|
| `<C-\>` | Toggle a floating terminal (like VS Code's Ctrl+\`) |
| `<Space>tt` | Terminal in a horizontal split |
| `<Space>tg` | Open **Lazygit** (needs the `lazygit` tool) |

### Learning aids

| Shortcut | Action |
|----------|--------|
| `<Space>H` | Toggle **Hardtime** (Vim-motion trainer) |
| `<Space>?` | **Open interactive cheatsheet** |
| `:Tutor` | Built-in 30-min Vim tutorial |
| `:set mouse=` | Disable the mouse to force keyboard-only (re-enable: `:set mouse=a`) |

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

## C / C++ / Game-engine development (OpenGL, Vulkan)

This setup includes a full native/graphics toolchain. **Inside Neovim** everything is
auto-installed via Mason (`clangd`, `clang-format`, `cmake-language-server`,
`glsl_analyzer`, `codelldb`); you only need the **system build tools** below.

### System dependencies

<details>
<summary><strong>Rocky Linux / RHEL (WSL2 or bare metal)</strong></summary>

```bash
# Compiler + build system
sudo dnf install -y gcc-c++ clang clang-tools-extra cmake ninja-build make gdb

# OpenGL dev libraries
sudo dnf install -y mesa-libGL-devel mesa-libGLU-devel glfw-devel glew-devel glm-devel

# Vulkan: headers, loader, validation layers + shader compilers (glslc / glslangValidator)
sudo dnf install -y vulkan-loader-devel vulkan-validation-layers vulkan-tools glslang glslc
```
</details>

<details>
<summary><strong>Arch Linux</strong></summary>

```bash
sudo pacman -S --noconfirm base-devel clang cmake ninja gdb
sudo pacman -S --noconfirm mesa glu glfw glew glm            # OpenGL
sudo pacman -S --noconfirm vulkan-headers vulkan-icd-loader vulkan-validation-layers vulkan-tools shaderc glslang   # Vulkan
```
</details>

> On WSL2, GPU acceleration works through WSLg (Mesa d3d12). For heavy Vulkan work you
> may prefer running the built binary on native Windows; editing/building/debugging in WSL is fine.

### What you get

| Area | Tool | Notes |
|------|------|-------|
| C/C++ intelligence | **clangd** | completion, go-to-def, diagnostics, inlay hints (clangd_extensions) |
| Formatting | **clang-format** | on save + `<Space>cf` (respects your `.clang-format`) |
| Build system | **cmake-tools.nvim** + cmake LSP | configure/build/run/debug from the editor |
| Debugging | **nvim-dap** + **codelldb** | breakpoints, stepping, watches, REPL (VS Code-style) |
| Shaders | **glsl_analyzer** + Treesitter `glsl` | `.vert/.frag/.comp/.geom/.tesc/.tese` + Vulkan `.rgen/.rchit/.rmiss/.rahit/.rint/.rcall/.mesh/.task` |
| Syntax | Treesitter `c`, `cpp`, `cmake`, `glsl` | |

### Workflow (CMake project)

```
1. Open the project root in Neovim (cd into it first, or use the Tmux sessionizer C-a f)
2. <Space>Cg   → :CMakeGenerate   (creates build/ + compile_commands.json for clangd)
3. <Space>Ct   → pick build type (Debug to debug, Release for speed)
4. <F7>        → build            (errors land in the quickfix: <Space>j / <Space>k to navigate)
5. <Space>Cr   → run  |  <Space>Cd → debug (breakpoints with <Space>db, then <F5>)
```

**clangd needs `compile_commands.json`.** `:CMakeGenerate` creates it (the config passes
`-DCMAKE_EXPORT_COMPILE_COMMANDS=ON` and soft-links it to the project root). For non-CMake
builds, generate it with [bear](https://github.com/rizsotto/Bear): `bear -- make`.

### Quick reference — C++ / Debug / CMake

| Shortcut | Action |
|----------|--------|
| `<Space>Cg` / `<Space>Cb` / `<F7>` | CMake generate / build |
| `<Space>Cr` / `<Space>Cd` | CMake run / debug |
| `<Space>Ct` / `<Space>Cl` | Select build type / launch target |
| `<F5>` | Debug: start / continue |
| `<F10>` / `<F11>` / `<Space>do` | Step over / into / out |
| `<Space>db` / `<Space>dB` | Toggle / conditional breakpoint |
| `<Space>du` / `<Space>de` | Toggle debug UI / eval expression |
| `<Space>dr` / `<Space>dt` | Toggle REPL / terminate |
| `K` · `gd` · `gr` · `<Space>ca` | Hover · definition · references · code action (clangd) |

> **Add Go/C# back later:** `gopls` and `omnisharp` were removed from the auto-install list.
> Once you install the Go/.NET toolchains, re-add them in `lua/user/lsp.lua`.

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
| **bufferline.nvim** | Visible editor tabs for open files |
| **conform.nvim** | Format on save (Prettier / stylua / gofmt) |
| **toggleterm.nvim** | Integrated terminal + Lazygit float |
| **indent-blankline.nvim** | Indent guides |
| **nvim-navic** | Code breadcrumbs in the winbar |
| **hardtime.nvim** | Vim-motion trainer — nudges you toward better motions |
| **precognition.nvim** | Live motion hints overlay (`:Precognition`) |
| **nvim-dap** (+ dap-ui, virtual-text) | Debugger: breakpoints, stepping, watches |
| **mason-nvim-dap** | Auto-installs `codelldb` (C/C++/Rust debugger) |
| **cmake-tools.nvim** | CMake configure/build/run/debug from Neovim |
| **clangd_extensions.nvim** | C++ inlay hints, AST, type hierarchy |
| **mason-tool-installer** | Auto-installs non-LSP tools (clang-format) |

