-- ~/.config/nvim/lua/user/lsp.lua
local mason            = require("mason")
local mason_lspconfig  = require("mason-lspconfig")
local lspconfig        = require("lspconfig")

-- ── Mason — automatic LSP server installer ───────────────
mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    "ts_ls",   -- TypeScript / JavaScript
    "html",    -- HTML
    "cssls",   -- CSS
    "eslint",  -- ESLint
    "lua_ls",  -- Lua (for editing Neovim configs)
  },
})

-- ── Completion (nvim-cmp) ────────────────────────────────
local cmp     = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<C-j>"]     = cmp.mapping.select_next_item(),
    ["<C-k>"]     = cmp.mapping.select_prev_item(),
    ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
    ["<C-f>"]     = cmp.mapping.scroll_docs(4),
    ["<C-e>"]     = cmp.mapping.abort(),
    ["<Tab>"]     = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"]   = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
  window = {
    completion    = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- ── LSP server configs ───────────────────────────────────
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.ts_ls.setup({ capabilities = capabilities })
lspconfig.html.setup({ capabilities = capabilities })
lspconfig.cssls.setup({ capabilities = capabilities })

-- Lua LS — configured for Neovim development (recognizes `vim` global)
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace   = {
        library        = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})
