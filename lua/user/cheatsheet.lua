-- ~/.config/nvim/lua/user/cheatsheet.lua
-- Interactive cheatsheet for VS Code users transitioning to Neovim.
-- Press <leader>? to open. Type what you'd do in VS Code and find the Vim way.

local M = {}

-- ┌──────────────────────────────────────────────────────────────────┐
-- │ Each entry: { keybinding, "what you want to do", category }     │
-- │ Written from a VS Code user's perspective so you can search     │
-- │ by the action you already know (e.g. "open file", "rename").    │
-- └──────────────────────────────────────────────────────────────────┘

M.entries = {

  -- ═══════════════════════════════════════════════════════════════
  -- MODES — The #1 thing to understand coming from VS Code
  -- In VS Code you're always in "insert" mode. Vim has modes.
  -- ═══════════════════════════════════════════════════════════════
  { "i",              "Enter INSERT mode (start typing text)",              "1. Modes",  "In VS Code you're always typing. In Vim, press i first." },
  { "Esc",            "Go back to NORMAL mode (stop typing)",              "1. Modes",  "This is like 'deactivating the cursor'. You MUST press Esc before using any navigation key." },
  { "v",              "Enter VISUAL mode (select text with movement)",     "1. Modes",  "Like holding Shift in VS Code, but you select with hjkl/motions instead of mouse." },
  { "V",              "Enter VISUAL LINE mode (select whole lines)",       "1. Modes",  "Like clicking the line number gutter in VS Code to select a full line." },
  { "<C-v>",          "Enter VISUAL BLOCK mode (column/box select)",       "1. Modes",  "Like VS Code's Alt+Click column selection." },
  { ":",              "Enter COMMAND mode (type a command)",                "1. Modes",  "Like VS Code's Ctrl+Shift+P command palette, but you type raw commands." },

  -- ═══════════════════════════════════════════════════════════════
  -- BASIC CURSOR MOVEMENT — replacing Arrow Keys and Mouse
  -- ═══════════════════════════════════════════════════════════════
  { "h / j / k / l",  "Move cursor left / down / up / right",             "2. Move",   "These replace arrow keys. Keep hands on home row. j=down k=up." },
  { "w",              "Jump forward to start of next word",                "2. Move",   "Like Ctrl+Right in VS Code but stops at word boundaries." },
  { "b",              "Jump backward to start of previous word",           "2. Move",   "Like Ctrl+Left in VS Code." },
  { "e",              "Jump forward to end of current/next word",          "2. Move",   "Lands at the last character of the word." },
  { "0",              "Go to beginning of line",                           "2. Move",   "Like Home key in VS Code." },
  { "^",              "Go to first non-blank character of line",           "2. Move",   "Like Home key but skips leading whitespace/indentation." },
  { "$",              "Go to end of line",                                 "2. Move",   "Like End key in VS Code." },
  { "gg",             "Go to first line of file",                          "2. Move",   "Like Ctrl+Home in VS Code." },
  { "G",              "Go to last line of file",                           "2. Move",   "Like Ctrl+End in VS Code." },
  { "{number}G",      "Go to specific line number (e.g. 42G)",            "2. Move",   "Like Ctrl+G in VS Code then typing the line number." },
  { "5j / 10k",       "Jump 5 lines down / 10 lines up",                  "2. Move",   "Combine a number + direction. Relative line numbers on the left help you count!" },
  { "<C-d>",          "Scroll half page down (cursor stays centered)",     "2. Move",   "Like PageDown but smoother — cursor stays in the middle of the screen." },
  { "<C-u>",          "Scroll half page up (cursor stays centered)",       "2. Move",   "Like PageUp but smoother." },
  { "%",              "Jump to matching bracket {} () []",                 "2. Move",   "Put cursor on a bracket and press %. Like VS Code's 'Go to Bracket'." },
  { "{ / }",          "Jump to previous / next blank line (paragraph)",    "2. Move",   "Quick way to skip between code blocks separated by empty lines." },

  -- ═══════════════════════════════════════════════════════════════
  -- FIND ON SCREEN — replacing Ctrl+F and mouse clicking
  -- ═══════════════════════════════════════════════════════════════
  { "f{char}",        "Jump to next {char} on current line",              "3. Find",   "Press f then a character. E.g. f( jumps to next (. Like a mini line-search." },
  { "F{char}",        "Jump to previous {char} on current line",          "3. Find",   "Same as f but searches backward on the line." },
  { "t{char}",        "Jump to just BEFORE next {char} on line",          "3. Find",   "Like f but stops one character before. Useful for dt) = delete until )." },
  { ";",              "Repeat last f/F/t/T jump forward",                  "3. Find",   "After pressing fa, press ; to jump to the next 'a' on the line." },
  { ",",              "Repeat last f/F/t/T jump backward",                 "3. Find",   "Opposite of ; — goes to previous match." },
  { "s + 2 chars",    "Jump to ANY visible text on screen (Flash)",       "3. Find",   "Press s then type 2 chars of where you want to go. Like teleporting your cursor!" },
  { "S",              "Select a code block using Treesitter (Flash)",      "3. Find",   "Press S and Flash highlights functions, blocks, etc. Pick one to select it." },
  { "/text",          "Search forward for 'text' in the file",            "3. Find",   "Like Ctrl+F in VS Code. Type /something and press Enter." },
  { "?text",          "Search backward for 'text' in the file",           "3. Find",   "Like Ctrl+F but searches upward." },
  { "n / N",          "Go to next / previous search result",              "3. Find",   "After searching with /, press n for next match, N for previous." },
  { "* / #",          "Search for word under cursor (next / prev)",       "3. Find",   "Put cursor on a variable name and press *. Instantly highlights all occurrences." },
  { "<Esc>",          "Clear search highlighting",                         "3. Find",   "After a search, press Esc to remove the yellow highlights." },

  -- ═══════════════════════════════════════════════════════════════
  -- OPEN & FIND FILES — replacing Ctrl+P, Ctrl+Shift+E, tabs
  -- ═══════════════════════════════════════════════════════════════
  { "<leader>ff",     "Find and open a file by name",                     "4. Files",  "Exactly like Ctrl+P in VS Code. Type part of the filename." },
  { "<C-p>",          "Find and open a file by name (alternative)",       "4. Files",  "Same as <leader>ff — the Ctrl+P shortcut you're used to." },
  { "<leader>fg",     "Search for text inside all files (grep)",          "4. Files",  "Like Ctrl+Shift+F in VS Code. Search across the entire project." },
  { "<leader>fr",     "Open a recently edited file",                      "4. Files",  "Shows files you edited recently, like VS Code's recent files list." },
  { "<leader>fb",     "Switch between open files (buffers)",              "4. Files",  "Like clicking tabs in VS Code. Shows all open files." },
  { "<leader>fw",     "Search all files for the word under cursor",       "4. Files",  "Put cursor on a word and instantly grep the whole project for it." },
  { "<leader>e",      "Toggle file explorer sidebar",                     "4. Files",  "Like Ctrl+Shift+E in VS Code. Opens/closes the file tree." },
  { "<Tab>",          "Switch to next open file (buffer)",                "4. Files",  "Like Ctrl+Tab in VS Code to cycle through open tabs." },
  { "<S-Tab>",        "Switch to previous open file (buffer)",            "4. Files",  "Like Ctrl+Shift+Tab in VS Code." },
  { "<leader>x",      "Close current file (buffer)",                      "4. Files",  "Like Ctrl+W to close the current tab in VS Code." },

  -- ═══════════════════════════════════════════════════════════════
  -- HARPOON — pin your working files (like VS Code pinned tabs)
  -- ═══════════════════════════════════════════════════════════════
  { "<leader>a",      "Pin current file to Harpoon (mark it)",           "5. Harpoon", "Like pinning a tab in VS Code, but faster. Mark the 3-5 files you're working on." },
  { "<leader>h",      "Show all pinned files (Harpoon menu)",            "5. Harpoon", "Opens a list of your pinned files. You can reorder or remove them." },
  { "<leader>1",      "Jump to pinned file #1 instantly",                "5. Harpoon", "No searching needed — instant switch. This is how pros navigate." },
  { "<leader>2",      "Jump to pinned file #2 instantly",                "5. Harpoon", "Pin your component, then pin the test file, then use 1/2 to jump between them." },
  { "<leader>3",      "Jump to pinned file #3 instantly",                "5. Harpoon", "Typical workflow: 1=component 2=styles 3=test 4=types." },
  { "<leader>4",      "Jump to pinned file #4 instantly",                "5. Harpoon", "" },
  { "<leader>5",      "Jump to pinned file #5 instantly",                "5. Harpoon", "" },

  -- ═══════════════════════════════════════════════════════════════
  -- EDIT TEXT — replacing mouse select, Ctrl+C, Ctrl+V, etc.
  -- ═══════════════════════════════════════════════════════════════
  { "i",              "Insert text BEFORE cursor",                        "6. Edit",   "Press i to start typing. Press Esc when done." },
  { "a",              "Insert text AFTER cursor",                         "6. Edit",   "Like i but places cursor one character to the right." },
  { "I",              "Insert text at BEGINNING of line",                 "6. Edit",   "Jumps to the start and enters insert mode. Saves you pressing Home then i." },
  { "A",              "Insert text at END of line",                       "6. Edit",   "Jumps to the end and enters insert mode. Saves you pressing End then a." },
  { "o",              "Open a new line BELOW and start typing",           "6. Edit",   "Like pressing End then Enter in VS Code. Creates a new line below." },
  { "O",              "Open a new line ABOVE and start typing",           "6. Edit",   "Creates a new line above current line and enters insert mode." },
  { "x",              "Delete character under cursor",                    "6. Edit",   "Like pressing Delete key." },
  { "dd",             "Delete (cut) entire current line",                 "6. Edit",   "Like Ctrl+Shift+K in VS Code. The line goes to clipboard (register)." },
  { "yy",             "Copy (yank) entire current line",                  "6. Edit",   "Like selecting the line and pressing Ctrl+C in VS Code." },
  { "p",              "Paste AFTER cursor (or below current line)",       "6. Edit",   "Like Ctrl+V in VS Code." },
  { "P",              "Paste BEFORE cursor (or above current line)",      "6. Edit",   "Same as p but pastes above/before." },
  { "u",              "Undo last change",                                 "6. Edit",   "Like Ctrl+Z in VS Code." },
  { "<C-r>",          "Redo (undo the undo)",                             "6. Edit",   "Like Ctrl+Shift+Z or Ctrl+Y in VS Code." },
  { ".",              "Repeat last edit action",                           "6. Edit",   "No VS Code equivalent! Did dd to delete a line? Press . to delete another." },
  { "gcc",            "Toggle comment on current line",                   "6. Edit",   "Like Ctrl+/ in VS Code." },
  { "gc (visual)",    "Toggle comment on selected lines",                 "6. Edit",   "Select lines with V, then press gc. Like Ctrl+/ on a selection." },
  { "J/K (visual)",   "Move selected lines up / down",                   "6. Edit",   "Like Alt+Up/Down in VS Code to move lines." },
  { "< / > (visual)", "Indent / outdent selected lines",                 "6. Edit",   "Like Tab / Shift+Tab on a selection in VS Code. Selection is kept!" },
  { "<leader>w",      "Save file",                                        "6. Edit",   "Like Ctrl+S in VS Code." },
  { "<leader>q",      "Quit Neovim",                                      "6. Edit",   "Closes the editor. Use :qa! to force-quit all files." },
  { "<leader>u",      "Open visual undo history (Undotree)",              "6. Edit",   "Way better than Ctrl+Z — shows a tree of ALL changes, even after save." },

  -- ═══════════════════════════════════════════════════════════════
  -- SELECT + OPERATE — the Vim superpower (verb + noun)
  -- In VS Code you select with mouse, then act. In Vim: action first.
  -- Pattern: {operator}{motion}  e.g. d + w = delete word
  -- ═══════════════════════════════════════════════════════════════
  { "dw",             "Delete from cursor to end of word",                "7. Verb+Noun", "d=delete, w=word. Like double-clicking a word and pressing Delete." },
  { "diw",            "Delete entire word (cursor anywhere in word)",     "7. Verb+Noun", "di = delete inside, w = word. No matter where cursor is in the word." },
  { "ciw",            "Change (replace) entire word",                     "7. Verb+Noun", "Deletes the word AND puts you in insert mode to type the new one." },
  { "ci\"",           "Change text inside quotes \"...\"",                "7. Verb+Noun", "Cursor anywhere inside quotes — deletes content and lets you type new text." },
  { "ci(",            "Change text inside parentheses (...)",             "7. Verb+Noun", "Same idea: delete inside () and type replacement." },
  { "ci{",            "Change text inside curly braces {...}",            "7. Verb+Noun", "Changes the content of the block. Amazing for function bodies." },
  { "ca{",            "Change text AND the braces themselves",            "7. Verb+Noun", "a = around. Deletes the braces too, not just content." },
  { "dit",            "Change text inside HTML/JSX tag",                  "7. Verb+Noun", "Cursor inside <div>hello</div>: dit deletes 'hello'." },
  { "di[",            "Change text inside square brackets [...]",         "7. Verb+Noun", "Works with any bracket type: ( ) { } [ ] < > \" ' `." },
  { "yiw",            "Copy (yank) word under cursor",                    "7. Verb+Noun", "y=yank(copy), iw=inner word. Then paste with p." },
  { "yi\"",           "Copy text inside quotes",                          "7. Verb+Noun", "Copies just the string content, without the quotes." },
  { "D",              "Delete from cursor to end of line",                "7. Verb+Noun", "Shortcut for d$. Deletes everything after the cursor." },
  { "C",              "Change from cursor to end of line",                "7. Verb+Noun", "Shortcut for c$. Deletes to end of line and enters insert mode." },
  { "vaf",            "Select entire function",                           "7. Verb+Noun", "v=visual, a=around, f=function. Selects the whole function." },
  { "vif",            "Select function body only",                        "7. Verb+Noun", "i=inside. Selects just the body, not the function signature." },
  { "daf",            "Delete entire function",                           "7. Verb+Noun", "One keystroke combo to delete a whole function!" },
  { "cif",            "Replace function body (change inner function)",    "7. Verb+Noun", "Deletes the function body and puts you in insert mode." },
  { "vac",            "Select entire class",                              "7. Verb+Noun", "" },
  { "vaa / via",      "Select parameter (outer / inner)",                 "7. Verb+Noun", "" },

  -- ═══════════════════════════════════════════════════════════════
  -- CLIPBOARD & REGISTERS — why paste sometimes loses your text
  -- ═══════════════════════════════════════════════════════════════
  { "<leader>y",      "Copy to system clipboard (OS clipboard)",         "8. Clipboard", "Vim has its OWN clipboard (register). This copies to Windows/Linux clipboard." },
  { "<leader>Y",      "Copy entire line to system clipboard",            "8. Clipboard", "" },
  { "<leader>p",      "Paste over selection WITHOUT losing copied text", "8. Clipboard", "In Vim, pasting over a selection replaces your clipboard. This preserves it." },
  { "<leader>D",      "Delete without copying (true delete)",            "8. Clipboard", "Normal d copies to register. This deletes without overwriting your clipboard." },
  { "<C-a>",          "Select all text in file",                          "8. Clipboard", "Like Ctrl+A in VS Code." },

  -- ═══════════════════════════════════════════════════════════════
  -- SURROUND — add/change/remove quotes, brackets, tags
  -- ═══════════════════════════════════════════════════════════════
  { "ysiw\"",         "Add \" quotes around the word under cursor",      "9. Surround", "ys=add surround, iw=inner word, \"=the character to wrap with." },
  { "ysiw)",          "Add () around the word under cursor",             "9. Surround", "" },
  { "cs'\"",          "Change surrounding ' to \" (single to double)",   "9. Surround", "cs=change surround, '=old char, \"=new char." },
  { "cs\"'",          "Change surrounding \" to ' (double to single)",   "9. Surround", "" },
  { "ds\"",           "Remove surrounding \" from around text",          "9. Surround", "ds=delete surround, \"=the char to remove." },
  { "ds)",            "Remove surrounding () from around text",          "9. Surround", "" },

  -- ═══════════════════════════════════════════════════════════════
  -- CODE INTELLIGENCE — replacing VS Code's F12, F2, hover, etc.
  -- ═══════════════════════════════════════════════════════════════
  { "gd",             "Go to definition (like F12 in VS Code)",          "10. Code",  "Press gd on a function/variable to jump to where it's defined." },
  { "gD",             "Go to declaration",                                "10. Code",  "Similar to gd but goes to the declaration (useful in some languages)." },
  { "gr",             "Find all references (like Shift+F12)",            "10. Code",  "Shows every place where the symbol is used." },
  { "gi",             "Go to implementation",                             "10. Code",  "For interfaces/abstract classes — jumps to the implementation." },
  { "K",              "Show hover documentation (like mouse hover)",     "10. Code",  "Press K on any symbol to see its type, docs — like hovering in VS Code." },
  { "<leader>ca",     "Open code actions (like Ctrl+. in VS Code)",      "10. Code",  "Quick fixes, refactoring options, auto-imports." },
  { "<leader>rn",     "Rename symbol across all files (like F2)",        "10. Code",  "Renames the variable/function everywhere in the project." },
  { "<leader>ld",     "Show error/warning for current line",             "10. Code",  "Like hovering over the red squiggly line in VS Code." },
  { "[d / ]d",        "Jump to previous / next error or warning",        "10. Code",  "Like F8 / Shift+F8 in VS Code to cycle through problems." },
  { "<leader>fd",     "Search all errors/warnings (like Problems tab)",  "10. Code",  "Opens a searchable list of all diagnostics, like VS Code's Problems panel." },
  { "<leader>fs",     "Find symbol in file (like Ctrl+Shift+O)",        "10. Code",  "Lists all functions, variables, types in the current file." },
  { "<C-Space>",      "Open autocomplete menu",                          "10. Code",  "Like how autocomplete appears when you type in VS Code." },
  { "<CR>",           "Accept autocomplete suggestion",                   "10. Code",  "Press Enter to confirm the selected completion." },
  { "<C-j>/<C-k>",   "Navigate autocomplete list up/down",              "10. Code",  "Like arrow keys in VS Code's autocomplete dropdown." },
  { "<C-e>",          "Dismiss autocomplete menu",                        "10. Code",  "Like pressing Escape on the autocomplete popup." },

  -- ═══════════════════════════════════════════════════════════════
  -- CODE STRUCTURE NAVIGATION — jumping between functions/classes
  -- ═══════════════════════════════════════════════════════════════
  { "]m",             "Jump to NEXT function",                            "11. Structure", "Cycles through functions in the file. Way faster than scrolling." },
  { "[m",             "Jump to PREVIOUS function",                        "11. Structure", "Go backward through functions." },
  { "]c",             "Jump to NEXT class",                               "11. Structure", "" },
  { "[c",             "Jump to PREVIOUS class",                           "11. Structure", "" },
  { "<leader>sn",     "Swap function parameter with next one",           "11. Structure", "Cursor on a param: reorders parameters. E.g. (a, b) → (b, a)." },
  { "<leader>sp",     "Swap function parameter with previous one",       "11. Structure", "" },
  { "<CR> (normal)",  "Start selecting, press again to expand",          "11. Structure", "Treesitter incremental selection: press Enter to grow selection smartly." },
  { "<BS>",           "Shrink treesitter selection",                      "11. Structure", "Undo one level of incremental selection." },

  -- ═══════════════════════════════════════════════════════════════
  -- WINDOWS & SPLITS — replacing VS Code's split editor
  -- ═══════════════════════════════════════════════════════════════
  { "<leader>sv",     "Split editor vertically (side by side)",          "12. Windows", "Like View > Split Editor in VS Code." },
  { "<leader>sh",     "Split editor horizontally (top and bottom)",      "12. Windows", "" },
  { "<C-h/j/k/l>",   "Move between editor splits (and Tmux panes!)",   "12. Windows", "This is the magic — same keys work in Neovim splits AND Tmux panes." },
  { "<C-Up/Down>",    "Make split taller / shorter",                     "12. Windows", "Resize splits with arrow keys." },
  { "<C-Left/Right>", "Make split wider / narrower",                     "12. Windows", "" },

  -- ═══════════════════════════════════════════════════════════════
  -- TMUX — the terminal multiplexer wrapping everything
  -- ═══════════════════════════════════════════════════════════════
  { "C-a |",          "[Tmux] Split terminal vertically",                "13. Tmux",  "Like opening a second terminal side-by-side." },
  { "C-a -",          "[Tmux] Split terminal horizontally",              "13. Tmux",  "Terminal above and below." },
  { "C-h/j/k/l",     "[Tmux] Navigate between ALL panes",              "13. Tmux",  "Same keys as Neovim splits! Seamless movement across everything." },
  { "Alt-h/j/k/l",   "[Tmux] Resize pane",                              "13. Tmux",  "" },
  { "C-a c",          "[Tmux] Open new window (like a VS Code tab)",    "13. Tmux",  "A tmux window is like a tab — each can have its own splits." },
  { "Alt-1..5",       "[Tmux] Switch to window 1-5",                     "13. Tmux",  " Like Alt+1 switches to tab 1 in VS Code." },
  { "C-a f",          "[Tmux] Switch project (sessionizer)",             "13. Tmux",  "Fuzzy-find a project folder and instantly switch to it. Each project = a session." },
  { "C-a [",          "[Tmux] Scroll up in terminal output",             "13. Tmux",  "Enters copy mode. Scroll with j/k. Press q to exit." },
  { "C-a r",          "[Tmux] Reload tmux config after changes",        "13. Tmux",  "" },

  -- ═══════════════════════════════════════════════════════════════
  -- HELP & DISCOVERY
  -- ═══════════════════════════════════════════════════════════════
  { "<leader>?",      "Open this cheatsheet!",                           "14. Help",  "You're here right now!" },
  { "<Space> (wait)", "Show all available shortcuts (which-key)",        "14. Help",  "Press Space and wait 300ms — a popup shows all leader key bindings." },
  { "<leader>fk",     "Search ALL keybindings (every single one)",       "14. Help",  "Like VS Code's Keyboard Shortcuts editor but searchable." },
  { "<leader>fh",     "Search Neovim help documentation",                "14. Help",  "Search the built-in docs. Type a topic like 'motion' or 'register'." },
  { ":Tutor",         "Open the built-in Vim tutorial",                   "14. Help",  "A 30-minute interactive tutorial built into Neovim. Great starting point!" },
}

-- ── Picker UI ────────────────────────────────────────────────────

function M.open()
  local pickers    = require("telescope.pickers")
  local finders    = require("telescope.finders")
  local conf       = require("telescope.config").values
  local previewers = require("telescope.previewers")

  local results = {}
  for _, entry in ipairs(M.entries) do
    table.insert(results, {
      key      = entry[1],
      desc     = entry[2],
      category = entry[3],
      tip      = entry[4] or "",
      ordinal  = entry[1] .. " " .. entry[2] .. " " .. entry[3] .. " " .. (entry[4] or ""),
    })
  end

  pickers.new({}, {
    prompt_title = " Cheatsheet — type what you'd do in VS Code",
    finder = finders.new_table({
      results = results,
      entry_maker = function(item)
        local icon = ({
          ["1. Modes"]      = " ",
          ["2. Move"]       = "󰆾 ",
          ["3. Find"]       = " ",
          ["4. Files"]      = " ",
          ["5. Harpoon"]    = "󱡀 ",
          ["6. Edit"]       = " ",
          ["7. Verb+Noun"]  = " ",
          ["8. Clipboard"]  = "󰅌 ",
          ["9. Surround"]   = "󰅪 ",
          ["10. Code"]      = " ",
          ["11. Structure"] = " ",
          ["12. Windows"]   = " ",
          ["13. Tmux"]      = " ",
          ["14. Help"]      = "󰋖 ",
        })[item.category] or "  "

        return {
          value   = item,
          display = string.format("%s%-18s │ %s", icon, item.key, item.desc),
          ordinal = item.ordinal,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      title = "How it works",
      define_preview = function(self, entry)
        local v = entry.value
        local lines = {
          "  ┌─────────────────────────────────────────────────┐",
          "  │  " .. v.category,
          "  └─────────────────────────────────────────────────┘",
          "",
          "  Keybinding:   " .. v.key,
          "",
          "  What it does: " .. v.desc,
          "",
        }

        if v.tip ~= "" then
          table.insert(lines, "  ─── VS Code comparison ────────────────────────")
          table.insert(lines, "")
          -- Wrap long tips
          local remaining = v.tip
          while #remaining > 0 do
            if #remaining <= 52 then
              table.insert(lines, "  " .. remaining)
              remaining = ""
            else
              local cut = remaining:sub(1, 52):match(".*()%s") or 52
              table.insert(lines, "  " .. remaining:sub(1, cut))
              remaining = remaining:sub(cut + 1)
            end
          end
          table.insert(lines, "")
        end

        table.insert(lines, "  ─── Quick tips ────────────────────────────────")
        table.insert(lines, "")
        table.insert(lines, "  <leader>fk  → search ALL keymaps")
        table.insert(lines, "  <Space>     → wait 300ms for which-key hints")
        table.insert(lines, "  :Tutor      → built-in Vim tutorial")
        table.insert(lines, "")

        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        -- Highlight the header
        pcall(vim.api.nvim_buf_add_highlight, self.state.bufnr, 0, "Title", 1, 0, -1)
      end,
    }),
    layout_config = {
      width = 0.85,
      height = 0.80,
      preview_width = 0.45,
    },
  }):find()
end

return M
