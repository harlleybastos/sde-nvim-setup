-- ~/.config/nvim/lua/user/quickref.lua
-- A glanceable, always-the-same "day-to-day guide" that lives INSIDE Neovim —
-- the in-editor replacement for a sticky note. Toggle with <Space>?.
-- Grouped by the tasks a VS Code dev actually does all day, in learning order.
-- (For "type the action you want" search, use <F1> -> the cheatsheet.)

local M = {}
M.win = nil

-- Each section: { title, rows = { {keys, "what it does (VS Code reflex)"}, ... } }
M.sections = {
  {
    title = "★ LOST IN A FILE? move by DISTANCE",
    rows = {
      { "same line",   "f{char} (then ; ,) · w / b by word · 0 / $ ends" },
      { "same screen", "s + 2 letters (Flash) · H / M / L · { } paragraphs" },
      { "whole file",  "/text search · gg / G / :N · ]m [m functions" },
      { "come back",   "<C-o> back · <C-i> forward · `` to last spot" },
    },
  },
  {
    title = "1 · MOVE THE CURSOR — basics",
    rows = {
      { "h j k l",       "left · down · up · right" },
      { "5j / 12k",      "jump N lines — read N off the left number column!" },
      { "w / b / e",     "next / previous word · end of word" },
      { "W / B / E",     "same but by WORD (skips punctuation)" },
      { "0 / ^ / $",     "line start · first non-blank · line end" },
      { "gg / G",        "top / bottom of file        (:N -> go to line N)" },
      { "{ / }",         "paragraph up / down" },
      { "<C-d> / <C-u>", "half page down / up (centered)" },
      { "%",             "jump to matching ( ) { } [ ]" },
    },
  },
  {
    title = "2 · MOVE FAST — pro motions",
    rows = {
      { "f{c} / t{c}",   "jump to / before char on line   (repeat: ; ,)" },
      { "s + 2 chars",   "jump ANYWHERE on screen (Flash)" },
      { "H / M / L",     "jump to top / middle / bottom of the screen" },
      { "zz",            "center the current line on screen (after a jump)" },
      { "* / #",         "next / prev occurrence of word under cursor" },
      { "gd / <C-o>",    "go to definition / jump back   (forward: <C-i>)" },
      { "]m / [m",       "next / previous function" },
      { "<Space>a · 1-5","Harpoon: pin file & jump straight to it" },
      { ".",             "repeat the last edit — the most powerful key" },
    },
  },
  {
    title = "3 · WINDOWS & SPLITS — move between panes",
    rows = {
      { "<C-h> / <C-l>", "move to LEFT / RIGHT split   (vertical)" },
      { "<C-j> / <C-k>", "move to DOWN / UP split      (horizontal)" },
      { "<Space>sv / sh","split vertical / horizontal" },
      { "<C-arrows>",    "resize the current split" },
      { "<C-w>o / <C-w>c","close all others (zoom) / close this split" },
      { "<C-w>=",        "make all splits equal size" },
    },
  },
  {
    title = "4 · FILE EXPLORER — jump tree <-> file",
    rows = {
      { "<Space>e",      "toggle the file tree        (Ctrl+Shift+E)" },
      { "<C-h> / <C-l>", "hop file -> tree / tree -> file" },
      { "<CR> / o",      "(in tree) open file / expand folder" },
      { "a / r / d",     "(in tree) create / rename / delete" },
      { "<C-v> / <C-x>", "(in tree) open in vertical / horizontal split" },
    },
  },
  {
    title = "5 · OPEN FILES — switch between buffers/tabs",
    rows = {
      { "<Tab> / <S-Tab>","next / previous open file      (Ctrl+Tab)" },
      { "<Space>bp",     "pick an open tab by letter" },
      { "<Space>a · 1-5","Harpoon: pin 3-5 files, jump instantly (best)" },
      { "<Space>fb",     "fuzzy-find among open buffers" },
      { "<Space>x / bo", "close this file / close all others" },
    },
  },
  {
    title = "6 · SEARCH — find files & text",
    rows = {
      { "<Space>ff",     "find file by name              (Ctrl+P)" },
      { "<Space>fg",     "search text across project     (Ctrl+Shift+F)" },
      { "<Space>fw",     "search the word under the cursor" },
      { "<Space>fr / fs","recent files / symbols in file  (Ctrl+Shift+O)" },
      { "/text  n / N",  "search in file · next / prev   (Ctrl+F)" },
      { "<Space>j / k",  "next / prev result in quickfix (after grep/build)" },
    },
  },
  {
    title = "7 · REPLACE — change & rename",
    rows = {
      { "<Space>rn",     "rename symbol (semantic)         (F2) <- use this" },
      { ":%s/old/new/g", "replace in file · add /gc to confirm  (Ctrl+H)" },
      { "V -> :s/o/n/g", "replace in the selection only" },
      { "* cgn … <Esc> .","multi-cursor: change one, repeat with .  (Ctrl+D)" },
      { "<C-v> I/A <Esc>","column edit                    (Alt+Click)" },
      { "<Space>fw <C-q>","-> :cdo s/o/n/g | update  = replace in project" },
    },
  },
  {
    title = "8 · EDIT FAST — the pro combos",
    rows = {
      { "ciw / ci\" / ci(","change word / inside quotes / inside parens" },
      { "daf / cif",     "delete whole function / change its body" },
      { "dd / yy / p",   "cut line / copy line / paste" },
      { "gcc / gc",      "comment line / selection        (Ctrl+/)" },
      { "J / K  (visual)","move selected lines down / up   (Alt+arrows)" },
      { "u / <C-r>",     "undo / redo   ·   <Space>u = undo tree" },
      { "ysiw\" · cs'\"","add / change surrounding quotes; ds\" removes" },
    },
  },
  {
    title = "9 · FORMAT",
    rows = {
      { "<Space>cf",     "format file / selection         (Shift+Alt+F)" },
      { "(on save)",     "auto-formats on <Space>w / :w" },
      { "gg=G",          "re-indent the whole file" },
    },
  },
  {
    title = "10 · DIAGNOSTICS / LINT",
    rows = {
      { "]d / [d",       "next / previous error or warning" },
      { "<Space>ld",     "show the current line's error (float)" },
      { "<Space>fd",     "list ALL problems in the project" },
      { "K · <Space>ca", "hover docs · quick fix / code action  (Ctrl+.)" },
    },
  },
  {
    title = "11 · BUILD & DEBUG — C/C++ · CMake",
    rows = {
      { "<Space>Cg",     "CMake: generate (compile_commands.json)" },
      { "<F7> · <Space>Cb","build" },
      { "<Space>Cr · Cd","run / debug" },
      { "<Space>db",     "toggle breakpoint   ·   <F5> continue" },
      { "<F10> / <F11>", "step over / step into   (out: <Space>do)" },
      { "<Space>du",     "toggle the debugger UI" },
    },
  },
  {
    title = "12 · TERMINAL & TMUX — move between environments",
    rows = {
      { "<C-\\>",        "floating terminal inside nvim   (Ctrl+`)" },
      { "<C-\\> <C-n>",  "leave terminal mode -> Normal (scroll/copy)" },
      { "<Space>tt · tg","split terminal · lazygit" },
      { "C-h/j/k/l",     "move across tmux panes AND nvim splits (same keys!)" },
      { "C-a | · C-a -", "[tmux] split pane vertical / horizontal" },
      { "C-a z",         "[tmux] zoom the current pane (focus)" },
      { "C-a c · Alt-1-5","[tmux] new window · switch window" },
      { "C-a f",         "[tmux] switch PROJECT (fzf sessionizer)" },
    },
  },
}

local INDENT = "    "
local KEY_W  = 22

-- Build the buffer lines + highlight specs { line, from_col, to_col, group }.
local function build()
  local lines, marks = {}, {}
  local function put(text, hls)
    table.insert(lines, text)
    local ln = #lines - 1
    if hls then for _, s in ipairs(hls) do table.insert(marks, { ln, s[1], s[2], s[3] }) end end
  end

  put("")
  local banner = "  Day-to-day guide — VS Code -> Neovim"
  put(banner, { { 0, #banner, "Title" } })
  local hint = "  q / <Esc> close  ·  <Space>? reopen  ·  <F1> search an action  ·  j/k scroll"
  put(hint, { { 0, #hint, "Comment" } })

  for _, sec in ipairs(M.sections) do
    put("")
    local title = "  ▌ " .. sec.title
    put(title, { { 0, #title, "Title" } })
    for _, r in ipairs(sec.rows) do
      local key, desc = r[1], r[2]
      local pad = math.max(2, KEY_W - vim.fn.strdisplaywidth(key))
      local text = INDENT .. key .. string.rep(" ", pad) .. desc
      put(text, { { #INDENT, #INDENT + #key, "Keyword" } })
    end
  end
  put("")
  return lines, marks
end

function M.toggle()
  -- already open? close it (toggle behaviour)
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
    M.win = nil
    return
  end

  local lines, marks = build()

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local ns = vim.api.nvim_create_namespace("user_quickref")
  for _, m in ipairs(marks) do
    pcall(vim.api.nvim_buf_set_extmark, buf, ns, m[1], m[2], { end_col = m[3], hl_group = m[4] })
  end

  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden  = "wipe"
  vim.bo[buf].filetype   = "quickref"

  local width = 0
  for _, l in ipairs(lines) do width = math.max(width, vim.fn.strdisplaywidth(l)) end
  width  = math.min(width + 2, vim.o.columns - 4)
  local height = math.min(#lines, vim.o.lines - 4)

  M.win = vim.api.nvim_open_win(buf, true, {
    relative  = "editor",
    width     = width,
    height    = height,
    row       = math.floor((vim.o.lines - height) / 2 - 1),
    col       = math.floor((vim.o.columns - width) / 2),
    style     = "minimal",
    border    = "rounded",
    title     = " Neovim · day-to-day ",
    title_pos = "center",
  })
  vim.wo[M.win].cursorline = true
  vim.wo[M.win].wrap = false

  local function close()
    if M.win and vim.api.nvim_win_is_valid(M.win) then vim.api.nvim_win_close(M.win, true) end
    M.win = nil
  end
  for _, key in ipairs({ "q", "<Esc>", "<Space>?" }) do
    vim.keymap.set("n", key, close, { buffer = buf, nowait = true, silent = true })
  end
end

return M
