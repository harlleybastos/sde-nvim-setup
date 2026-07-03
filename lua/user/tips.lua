-- ~/.config/nvim/lua/user/tips.lua
-- A tiny "learn a little every session" system. Shows one short, practical tip
-- on startup and on demand (:Tip). Every tip teaches a pro move from THIS config.
-- Pairs with hardtime.nvim (reactive nudges) and precognition (live motion hints).

local M = {}

M.tips = {
  "Press  .  to repeat your last edit — the single biggest time-saver in Vim.",
  "ciw changes the whole word under the cursor, no matter where you are in it.",
  "s + 2 letters (Flash) jumps anywhere on screen — faster than the mouse.",
  "After gd (go to definition), press <C-o> to jump back where you were.",
  "Pin files with <Space>a and jump with <Space>1-5 (Harpoon) — your fixed tabs.",
  'ci" changes inside quotes; ci( inside parens; cit inside an HTML/JSX tag.',
  "* searches the word under the cursor; n / N cycle the matches.",
  "daf deletes the whole function; cif changes just its body (Treesitter).",
  "<Space>fg greps the whole project — like Ctrl+Shift+F in VS Code.",
  "Multi-cursor the Vim way:  *  then  cgn , type, <Esc>, then  . . .  on each match.",
  "f{char} jumps to that char on the line;  ;  repeats it,  ,  goes back.",
  "0 = line start · ^ = first non-blank · $ = line end.",
  "<C-d> / <C-u> scroll half a page and keep the cursor centered.",
  "In VISUAL mode, J / K move the selected lines down / up (Alt+arrows in VS Code).",
  "In visual mode > and < indent AND keep the selection — press again to repeat.",
  "yiw copies the word under the cursor; then p pastes it. (y = yank = copy)",
  "gcc comments the current line; gc comments a selection (Ctrl+/).",
  "<Space>rn renames a symbol everywhere — semantic, better than find-and-replace.",
  ":%s/old/new/gc replaces in the file and asks y/n on each match.",
  "]m / [m jump to the next / previous function — way faster than scrolling.",
  "<Space>cf formats the file; it also formats automatically when you save.",
  "%  jumps between matching ( ) { } [ ].",
  "dt) deletes up to the next ) · ct, changes up to the next comma.",
  "A / I enter insert mode at the END / START of the line in one key.",
  "o opens a new line below and O above — no need to reach for the end first.",
  "u undoes · <C-r> redoes · <Space>u opens the full undo tree.",
  "gg = top of file · G = bottom · 42G = jump to line 42.",
  "V selects whole lines · <C-v> selects a column/block (then I or A to type).",
  "K shows docs / hover for the symbol under the cursor.",
  "<Space>fw searches the whole project for the word under your cursor.",
  "In tmux, C-a z zooms the current pane to fullscreen — press again to unzoom.",
  "C-a f (tmux) fuzzy-switches between projects instantly.",
  "C-h/j/k/l moves between Neovim splits AND tmux panes with the same keys.",
  "C++: run <Space>Cg once in a project so clangd understands all your #includes.",
  "Set a breakpoint with <Space>db, then <F5> to start debugging (F10/F11 to step).",
  "Stuck? <Space>? opens the day-to-day guide · <Space> and wait shows which-key.",
}

-- hrtime() changes every call, so this rotates without needing a seeded RNG.
local function pick()
  local uv = vim.uv or vim.loop
  return M.tips[(uv.hrtime() % #M.tips) + 1]
end

function M.show()
  vim.notify(pick(), vim.log.levels.INFO, { title = "💡 Neovim tip  (:Tip for another)" })
end

return M
