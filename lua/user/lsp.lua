-- ~/.config/nvim/lua/user/lsp.lua
local mason           = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    "ts_ls", "solargraph", "clangd", "omnisharp", "gopls",
    "html", "cssls", "tailwindcss", "angularls", "emmet_ls",
    "eslint", "biome", "prismals", "jsonls", "yamlls",
    "dockerls", "docker_compose_language_service", "terraformls",
    "lua_ls",
  },
})

-- ── Completion ───────────────────────────────────────────
local cmp     = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<C-j>"]     = cmp.mapping.select_next_item(),
    ["<C-k>"]     = cmp.mapping.select_prev_item(),
    ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
    ["<C-f>"]     = cmp.mapping.scroll_docs(4),
    ["<C-e>"]     = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
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

-- ── Capabilities ─────────────────────────────────────────
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ── Servidores simples (nova API) ────────────────────────
local simple_servers = {
  "html", "cssls", "tailwindcss", "angularls",
  "emmet_ls", "eslint", "biome", "prismals",
  "solargraph", "clangd", "dockerls",
  "docker_compose_language_service", "terraformls",
  "ts_ls",
}
for _, server in ipairs(simple_servers) do
  vim.lsp.config(server, { capabilities = capabilities })
  vim.lsp.enable(server)
end

-- ── OmniSharp (C#) ──────────────────────────────────────
vim.lsp.config("omnisharp", {
  capabilities = capabilities,
  settings = {
    FormattingOptions = { EnableEditorConfigSupport = true },
    RoslynExtensionsOptions = { EnableAnalyzersSupport = true },
  },
})
vim.lsp.enable("omnisharp")

-- ── Go ───────────────────────────────────────────────────
vim.lsp.config("gopls", {
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses    = { unusedparams = true, shadow = true },
      staticcheck = true,
      gofumpt     = true,
    },
  },
})
vim.lsp.enable("gopls")

-- ── JSON ─────────────────────────────────────────────────
local schemastore_ok, schemastore = pcall(require, "schemastore")
vim.lsp.config("jsonls", {
  capabilities = capabilities,
  settings = {
    json = {
      schemas  = schemastore_ok and schemastore.json.schemas() or {},
      validate = { enable = true },
    },
  },
})
vim.lsp.enable("jsonls")

-- ── YAML ─────────────────────────────────────────────────
vim.lsp.config("yamlls", {
  capabilities = capabilities,
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas     = schemastore_ok and schemastore.yaml.schemas() or {},
      validate    = true,
    },
  },
})
vim.lsp.enable("yamlls")

-- ── Lua ──────────────────────────────────────────────────
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace   = {
        library         = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.enable("lua_ls")
