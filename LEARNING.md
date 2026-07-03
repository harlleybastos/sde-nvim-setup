# Learning this setup (VS Code → Neovim, for real daily work)

A practical guide to leave VS Code + mouse behind and become fluent in Neovim + Tmux
**without killing your productivity**. Tuned for *this* config — every key below is one
that's already wired up here.

> **`leader` = Space.** When you read `<Space>ff`, it's Space then `ff`.
> **Stuck? Press `<Space>?`** — opens the **day-to-day guide**: a panel grouped by task
> (move · search · replace · format · build · tmux), always the same, made to glance at.
> And **`<F1>`** opens the searchable cheatsheet: type what you'd do in VS Code
> ("rename", "find file", "comment") and it shows you the Vim way.

---

## The two in-editor helpers (your real "sticky note")

You don't need an external cheatsheet — it's built in:

- **`<Space>?`** → the **glanceable day-to-day panel** (12 sections, in learning order).
  Toggle it open/closed. Also `:Guide`. Edit it in `lua/user/quickref.lua`.
- **`<F1>`** → the **searchable cheatsheet**. Type the action, get the keys. Also `:Cheatsheet`.
- **`<Space>`** and wait → **which-key** shows every leader binding live.

Prefer paper? Here's a compact version to print:

```
NEOVIM — daily                                       stuck? <Space>?
move:    w/b word · 0/$ line · gg/G file · f{c} char · { } paragraph
fast:    s + 2 letters = jump on screen · <C-o> back · . repeat edit
panes:   <C-h/l> left/right split · <C-j/k> down/up · same keys in tmux!
explorer:<Space>e toggle · <C-h>/<C-l> hop tree<->file
files:   <Tab> switch open file · <Space>a pin · <Space>1-5 jump (Harpoon)
search:  <Space>ff file · <Space>fg text · <Space>fw word under cursor
replace: <Space>rn rename symbol · :%s/old/new/g · * cgn … <Esc> . (multi)
edit:    ciw change word · ci" inside quotes · daf del func · gcc comment
format:  <Space>cf (auto on save) · save <Space>w
code:    gd def · gr uses · K docs · [d ]d errors · <C-Space> complete
C++:     <Space>Cg generate · F7 build · <Space>Cd debug · <Space>db bp
tmux(C-a): | - split · C-h/j/k/l move · C-a z zoom · C-a f switch project
```

---

## Learn while you work (automatic feedback)

Three things teach you as you go — no studying required:

- **Tips on startup** — every launch shows one short pro tip from this config. Want
  another right now? `:Tip`.
- **Hardtime nudges** — mash `j`/`k` or the arrow keys and it suggests a better motion
  (*"you pressed `j` too many times…"*). Toggle with `<Space>H`; switch it to **block**
  mode in `lua/user/plugins.lua` when you want it to *enforce*, not just warn.
- **Precognition** (motion X-ray) — run `:Precognition` to overlay the exact keys
  (`w b e ^ $ f` …) that jump where you're looking. Perfect for drilling motions; run it
  again to turn it off once they're automatic.

---

## The mindset (read once)

1. **Vim has modes.** In VS Code you're always "typing". In Vim: `i` to type, `Esc`
   to navigate/command. You'll spend ~90% of the time in NORMAL mode, editing with commands.
2. **Verb + target.** Instead of selecting with the mouse and then acting, you state the
   action: `d`elete, `c`hange, `y`ank(copy) + the target: `iw` (inner word), `i"` (inside
   quotes), `af` (a function). E.g. `ciw` = change the word; `daf` = delete the whole function.
3. **Golden rule:** every time your hand reaches for the **mouse or arrow keys**, stop for
   2 seconds, press `<Space>?`, and find the keyboard way. You learn in the real flow of work.
4. **One new thing per week.** Don't memorize everything. Master 1 motion until it's automatic,
   then add another. `hardtime` (already on) nudges you when you mash a key — leave it on
   (`<Space>H` toggles it).

---

## The plan, in phases

### Phase 0 — today (30 min)
Run **`:Tutor`** end to end. Best initial investment there is. Just once.

### Phase 1 — survive (week 1) · mouse still on
`i` edit · `Esc` normal · `hjkl` move · `<Space>w` save · `<Space>ff` open file ·
`<Space>e` tree · `u` undo.
**Goal: get through a day without switching back to VS Code.**

### Phase 2 — motions + verb·target (weeks 2–3) · 80% of the payoff lives here
Move: `w`/`b`/`e`, `f{char}`, `0`/`$`, `{`/`}`, `5j`.
Edit: `ciw`, `ci"`, `dd`/`yy`/`p`, `gcc`, and the **`.`** (repeat last edit — addictive).
Jump back where you came from: `<C-o>` / `<C-i>`.
**Goal: stop using the arrow keys.**

### Phase 3 — navigate a project (weeks 3–4)
`<Space>fg` project grep · `gd`/`gr`/`K` code · **Harpoon** (`<Space>a` pin, `<Space>1..5`
jump) · `s`+2 letters (Flash) jump on screen · splits + tmux.
**Goal: navigate a real project without touching the mouse.**

### Phase 4 — fluency + C++ (month 2+)
Textobjects (`daf`, `cif`, `]m`), debugging, CMake, macros.
**Take off the training wheels:** `:set mouse=` (mouse off) and `<Space>H` → hardtime block mode.

---

## 🏋️ Daily drill (5 min, inside Neovim, on real code)

**Fixed warm-up (every day, 2 min):** open a file, hop with `w`/`f{char}`, change 3 words
with `ciw`, comment a block with `gcc`, save with `<Space>w`. No arrow keys.

Then the focus of the day:

| Day | Focus | Exercise |
|----:|-------|----------|
| 1  | Tutor        | Run `:Tutor` end to end |
| 2  | hjkl         | A whole day on `hjkl` only, zero arrow keys |
| 3  | words        | `w` `b` `e` `0` `$` — cross 30 lines with just these |
| 4  | cut/paste    | `dd` `yy` `p` `u` `<C-r>` — reorder 10 lines |
| 5  | files        | Open 10 files using only `<Space>ff` and `<Space>e` |
| 6  | change word  | `ciw` / `diw` — change/delete 20 words |
| 7  | delimiters   | `ci"` `ci(` `ci{` `dt)` — edit inside them 15× |
| 8  | line search  | `f{char}` `t{char}` + `;` `,` — hop on a line without counting |
| 9  | the dot `.`  | Make 1 edit, repeat it with `.` ten times |
| 10 | blocks       | `gcc` comment, `>`/`<` indent, `J`/`K` move (visual) |
| 11 | Harpoon      | Pin 4 files, work by jumping with `<Space>1-4` |
| 12 | splits       | `<Space>sv` + `<C-h/j/k/l>` + tmux `C-a \|` — never touch the mouse |
| 13 | grep         | `<Space>fg` — find 10 things across the project |
| 14 | LSP          | `gd` → `<C-o>` (jump & back) · `gr` uses · `K` docs |
| 15 | Flash        | `s` + 2 letters — jump 20× around the screen |
| 16 | functions    | `vaf` `daf` `cif` on a real function |
| 17 | structure    | `]m` `[m` hop functions · `<Space>fs` symbols |
| 18 | CMake        | `<Space>Cg` → `<F7>` → run the binary |
| 19 | Debug        | breakpoint `<Space>db` → `<F5>` → `<F10>`/`<F11>` |
| 20 | refactor     | `<Space>rn` rename · `<Space>ca` fix · `<Space>cf` format |
| 21 | wheels off   | `:set mouse=` + hardtime block — work a full day like this |

Done with 21 days? Repeat the ones that still feel heavy. Fluency comes from reps.

---

## A day of real work (the loop)

```
1. tmux:  C-a f        -> pick the project (each project = a session)
2.        C-a |        -> split: nvim on one side, terminal on the other
3. nvim:  <Space>a pins the files you're on; <Space>1..5 hops between them
4.        edit with motions; <Space>w saves (auto-formats on save)
5.        C-h/j/k/l    -> hop to the terminal (same keys as splits!) and run/test
```
`C-h/j/k/l` moves between Neovim splits **and** tmux panes without thinking. That's the trick.

---

## C / C++ / game (OpenGL, Vulkan) — end to end

```
1. cd into the project and open nvim (or C-a f in tmux)
2. <Space>Cg   -> :CMakeGenerate  (writes compile_commands.json -> clangd understands EVERYTHING)
3. <Space>Ct   -> pick "Debug"
4. <F7>        -> build   (errors go to the quickfix: <Space>j / <Space>k to navigate)
5. <Space>db on a line -> <F5> -> debugging; F10 step over, F11 step into, <Space>do step out
6. <Space>cf   -> format (clang-format); or just save and it formats
```
> **First time in a C++ project:** run `<Space>Cg` before anything else. Without
> `compile_commands.json`, clangd is half-blind (red squiggles on your `#include`s).
> Shaders (`.vert`/`.frag`/`.comp`/`.rgen`…) already get highlight + LSP automatically.

---

## When you get stuck (safety net)

| Press | What it does |
|-------|--------------|
| `<Space>?` | **Day-to-day guide** — panel grouped by task (glance at it) |
| `<F1>` | Searchable cheatsheet — type the action ("rename", "find file") |
| `<Space>` then wait | which-key shows everything under Space |
| `<Space>fk` | Search **all** keymaps |
| `<Space>fh` | Search the Neovim docs |
| `:LspInfo` / `:Mason` | Did the LSP attach? / Is the server installed? |
| `:ConformInfo` | Which formatter runs in this file |
| `:checkhealth` | Overall health of the setup |

---

## Quick reference by theme

**Move:** `h j k l` · `w b e` word · `0 ^ $` line · `gg G` file · `{n}G` line n ·
`f{c}`/`t{c}` on line · `%` matching bracket · `{ }` paragraph · `<C-d>/<C-u>` half page ·
`s`+2 letters (Flash) · `<C-o>/<C-i>` jumplist.

**Windows/splits:** `<C-h/j/k/l>` move between splits (and tmux panes) · `<Space>sv/sh` split ·
`<C-arrows>` resize · `<C-w>o` only-this · `<C-w>c` close · `<C-w>=` equalize.

**Files:** `<Space>ff` open · `<Space>fg` grep · `<Space>fr` recent · `<Space>e` tree ·
`<Space>a` pin / `<Space>1-5` jump (Harpoon) · `<Tab>`/`<S-Tab>` tabs · `<Space>x` close.

**Edit:** `i a o` insert · `x` del char · `dd yy p` line · `u`/`<C-r>` undo/redo · `.` repeat ·
`ciw/diw` word · `ci"/ci(/ci{` inside · `daf/cif` function · `gcc` comment · `ysiw"` surround.

**Replace:** `<Space>rn` rename symbol · `:%s/old/new/g` (`/gc` confirm) · `V :s/…` selection ·
`* cgn … <Esc> .` multi-cursor · `<Space>fw <C-q> :cdo s/old/new/g | update` project-wide.

**Code (LSP):** `gd` def · `gD` decl · `gr` uses · `gi` impl · `gy` type · `K` docs ·
`<Space>ca` fix · `<Space>rn` rename · `[d`/`]d` errors · `<C-Space>` complete · `<Space>cf` format.

**C++/CMake/Debug:** `<Space>Cg` generate · `<F7>`/`<Space>Cb` build · `<Space>Cr` run ·
`<Space>Cd` debug · `<F5>` continue · `<F10>/<F11>` step over/into · `<Space>db` breakpoint ·
`<Space>du` UI · `<Space>de` eval.

**Terminal/git:** `<C-\>` floating terminal · `<Space>tt` split terminal · `<Space>tg` lazygit.

**Tmux (prefix `C-a`):** `\|`/`-` split · `C-h/j/k/l` move · `Alt-h/j/k/l` resize ·
`C-a z` zoom pane · `C-a c` new window · `Alt-1..5` window · `C-a f` sessionizer · `C-a [` copy mode.

---

## Taking off the training wheels (when you're ready)

- `:set mouse=` disables the mouse (re-enable with `:set mouse=a`). Force yourself onto the keyboard.
- `<Space>H` toggles Hardtime; set `restriction_mode` to `"block"` in `lua/user/plugins.lua`
  when you want it to **stop** (not just warn about) inefficient keys.
- Final goal: a full day with no mouse and no arrow keys. Once that feels natural, you've
  crossed over — and you won't go back.

Happy hacking. 🚀
