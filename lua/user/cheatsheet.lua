-- ~/.config/nvim/lua/user/cheatsheet.lua
-- Interactive navigation cheatsheet — press <leader>? to open
-- Searchable via Telescope: type what you WANT TO DO and find the keybinding.

local M = {}

-- Each entry: { keybinding, description, category }
-- Describe actions from the USER's perspective ("I want to...")
M.entries = {
  -- ── File navigation ────────────────────────────────────
  { "<leader>ff",     "Find a file by name",                        "Files" },
  { "<leader>fr",     "Open a recently edited file",                "Files" },
  { "<leader>fg",     "Search text across all files (grep)",        "Files" },
  { "<leader>fb",     "Switch between open buffers",                "Files" },
  { "<leader>fw",     "Search for the word under the cursor",       "Files" },
  { "<C-p>",          "Find files (alternative shortcut)",          "Files" },
  { "<leader>e",      "Toggle the file tree explorer",              "Files" },

  -- ── Harpoon (instant file switching) ───────────────────
  { "<leader>a",      "Mark current file in Harpoon",               "Harpoon" },
  { "<leader>h",      "Open the Harpoon quick menu",                "Harpoon" },
  { "<leader>1..5",   "Jump to Harpoon file 1-5",                   "Harpoon" },

  -- ── Jump / move on screen ─────────────────────────────
  { "s + 2 chars",    "Jump to any visible text (Flash)",           "Jump" },
  { "S",              "Treesitter-aware selection (Flash)",          "Jump" },
  { "<C-d>",          "Scroll half page down (centered)",           "Jump" },
  { "<C-u>",          "Scroll half page up (centered)",             "Jump" },
  { "{ / }",          "Jump to previous / next paragraph",          "Jump" },
  { "gg / G",         "Jump to start / end of file",                "Jump" },
  { "5j / 10k",       "Jump 5 lines down / 10 up (rel. numbers)",  "Jump" },
  { "f{char}",        "Jump to character on current line",          "Jump" },
  { "%",              "Jump to matching bracket / parenthesis",      "Jump" },
  { "* / #",          "Search word under cursor (next / prev)",     "Jump" },
  { "n / N",          "Next / previous search result (centered)",   "Jump" },

  -- ── Code navigation (LSP) ─────────────────────────────
  { "gd",             "Go to definition",                           "LSP" },
  { "gD",             "Go to declaration",                          "LSP" },
  { "gr",             "Show all references",                        "LSP" },
  { "gi",             "Go to implementation",                       "LSP" },
  { "K",              "Hover documentation",                        "LSP" },
  { "<leader>ca",     "Code actions (fix, refactor)",               "LSP" },
  { "<leader>rn",     "Rename symbol across files",                 "LSP" },
  { "<leader>ld",     "Show line diagnostics (errors/warnings)",    "LSP" },
  { "<leader>fd",     "Search all diagnostics (Telescope)",         "LSP" },
  { "<leader>fs",     "Search document symbols (Telescope)",        "LSP" },
  { "[d / ]d",        "Previous / next diagnostic",                 "LSP" },

  -- ── Treesitter textobjects ─────────────────────────────
  { "vaf",            "Select entire function",                     "Textobjects" },
  { "vif",            "Select function body only",                  "Textobjects" },
  { "vac",            "Select entire class",                        "Textobjects" },
  { "vic",            "Select class body only",                     "Textobjects" },
  { "vaa / via",      "Select parameter (outer / inner)",           "Textobjects" },
  { "val / vil",      "Select loop (outer / inner)",                "Textobjects" },
  { "daf",            "Delete entire function",                     "Textobjects" },
  { "cif",            "Change function body",                       "Textobjects" },
  { "]m / [m",        "Next / previous function",                   "Textobjects" },
  { "]c / [c",        "Next / previous class",                      "Textobjects" },
  { "<leader>sn",     "Swap parameter with next",                   "Textobjects" },
  { "<leader>sp",     "Swap parameter with previous",               "Textobjects" },

  -- ── Editing ────────────────────────────────────────────
  { "gcc",            "Toggle comment on current line",             "Edit" },
  { "gc (visual)",    "Toggle comment on selection",                "Edit" },
  { "J/K (visual)",   "Move selected lines up / down",             "Edit" },
  { "J (normal)",     "Join lines (cursor stays in place)",         "Edit" },
  { "<leader>p",      "Paste over selection without losing yank",   "Edit" },
  { "<leader>y",      "Yank to system clipboard",                   "Edit" },
  { "<leader>Y",      "Yank entire line to clipboard",              "Edit" },
  { "<leader>D",      "Delete without yanking",                     "Edit" },
  { "< / > (visual)", "Indent / outdent keeping selection",         "Edit" },
  { "<C-a>",          "Select all text in file",                    "Edit" },
  { "<leader>u",      "Toggle Undotree (visual undo history)",      "Edit" },

  -- ── Surround ──────────────────────────────────────────
  { "cs'\"",          "Change surrounding ' to \"",                 "Surround" },
  { "ysiw\"",         "Add \" around word",                         "Surround" },
  { "ds\"",           "Remove surrounding \"",                      "Surround" },
  { "ysa\")",         "Add () around \"...\" block",                "Surround" },

  -- ── Buffers & windows ─────────────────────────────────
  { "<Tab>",          "Go to next buffer",                          "Buffers" },
  { "<S-Tab>",        "Go to previous buffer",                      "Buffers" },
  { "<leader>x",      "Close current buffer",                       "Buffers" },
  { "<leader>sv",     "Split window vertically",                    "Windows" },
  { "<leader>sh",     "Split window horizontally",                  "Windows" },
  { "<C-h/j/k/l>",   "Move between splits & Tmux panes",          "Windows" },
  { "<C-arrows>",     "Resize split",                               "Windows" },

  -- ── Quickfix ──────────────────────────────────────────
  { "<leader>j",      "Next quickfix item",                         "Quickfix" },
  { "<leader>k",      "Previous quickfix item",                     "Quickfix" },

  -- ── General ───────────────────────────────────────────
  { "<leader>w",      "Save file",                                  "General" },
  { "<leader>q",      "Quit",                                       "General" },
  { "<Esc>",          "Clear search highlight",                     "General" },
  { "<leader>fk",     "Search all keymaps (Telescope)",             "General" },
  { "<leader>fh",     "Search help tags (Telescope)",               "General" },
  { "<leader>?",      "Open this cheatsheet",                       "General" },

  -- ── Tmux ──────────────────────────────────────────────
  { "C-a |",          "[Tmux] Split pane vertically",               "Tmux" },
  { "C-a -",          "[Tmux] Split pane horizontally",             "Tmux" },
  { "C-a c",          "[Tmux] New window",                          "Tmux" },
  { "Alt-1..5",       "[Tmux] Switch to window 1-5",               "Tmux" },
  { "C-a f",          "[Tmux] Sessionizer (switch project)",        "Tmux" },
  { "C-a [",          "[Tmux] Enter copy mode (vi keys)",           "Tmux" },
  { "C-a r",          "[Tmux] Reload tmux config",                  "Tmux" },
  { "Alt-h/j/k/l",   "[Tmux] Resize pane",                         "Tmux" },

  -- ── Completion ────────────────────────────────────────
  { "<C-Space>",      "Trigger autocomplete menu",                  "Completion" },
  { "<CR>",           "Confirm completion",                         "Completion" },
  { "<C-j> / <C-k>", "Next / previous completion item",            "Completion" },
  { "<Tab> / <S-Tab>","Next / prev item or jump in snippet",       "Completion" },
  { "<C-e>",          "Dismiss completion menu",                    "Completion" },
  { "<C-b> / <C-f>",  "Scroll completion docs up / down",          "Completion" },
}

function M.open()
  local pickers    = require("telescope.pickers")
  local finders    = require("telescope.finders")
  local conf       = require("telescope.config").values
  local previewers = require("telescope.previewers")

  -- Build display lines: "  keybinding  │  description  [category]"
  local results = {}
  for _, entry in ipairs(M.entries) do
    table.insert(results, {
      display  = string.format("%-20s │ %-48s [%s]", entry[1], entry[2], entry[3]),
      key      = entry[1],
      desc     = entry[2],
      category = entry[3],
      ordinal  = entry[1] .. " " .. entry[2] .. " " .. entry[3],
    })
  end

  pickers.new({}, {
    prompt_title = " Navigation Cheatsheet  —  type what you want to do",
    finder = finders.new_table({
      results = results,
      entry_maker = function(item)
        return {
          value   = item,
          display = item.display,
          ordinal = item.ordinal,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      title = "Details",
      define_preview = function(self, entry)
        local v = entry.value
        local lines = {
          "",
          "  Keybinding:  " .. v.key,
          "",
          "  Action:      " .. v.desc,
          "",
          "  Category:    " .. v.category,
          "",
          string.rep("─", 50),
          "",
          "  TIP: Press <leader>fk to search ALL keymaps.",
          "        Press <Space> and wait to see which-key hints.",
        }
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      end,
    }),
  }):find()
end

return M
