-- ~/.config/nvim/lua/user/lsp.lua
-- Full-stack LSP configuration.
-- Servers are automatically installed via Mason on first launch.
-- Just open a file and Mason handles the rest.

local mason           = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig       = require("lspconfig")

-- ── Mason — automatic LSP server installer ───────────────
mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    -- Core languages
    "ts_ls",           -- TypeScript / JavaScript / Node / React / Next / Angular
    "solargraph",      -- Ruby / Ruby on Rails
    "clangd",          -- C / C++
    "omnisharp",       -- C#
    "gopls",           -- Go

    -- Frontend
    "html",            -- HTML
    "cssls",           -- CSS / SCSS
    "tailwindcss",     -- TailwindCSS class autocomplete
    "angularls",       -- Angular templates
    "emmet_ls",        -- Emmet abbreviations (HTML/JSX shorthand)
    "eslint",          -- ESLint (JS/TS linting + auto-fix)
    "biome",           -- Biome (fast linter + formatter for JS/TS/JSON/CSS)

    -- Backend / Data
    "prismals",        -- Prisma ORM schemas
    "jsonls",          -- JSON (with schema support for package.json, tsconfig, etc.)
    "yamlls",          -- YAML (docker-compose, GitHub Actions, k8s manifests)

    -- DevOps
    "dockerls",                        -- Dockerfile
    "docker_compose_language_service", -- docker-compose.yml
    "terraformls",                     -- Terraform (.tf files)

    -- Editor
    "lua_ls",          -- Lua (for editing this Neovim config)
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

-- ── Shared capabilities (sent to every LSP server) ──────
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ── Servers with default config (no special settings) ────
local simple_servers = {
  "html",
  "cssls",
  "tailwindcss",
  "angularls",
  "emmet_ls",
  "eslint",
  "biome",            -- Biome (JS/TS/JSON/CSS linter + formatter)
  "prismals",
  "solargraph",     -- Ruby / Rails
  "clangd",         -- C / C++
  "dockerls",
  "docker_compose_language_service",
  "terraformls",
}
for _, server in ipairs(simple_servers) do
  lspconfig[server].setup({ capabilities = capabilities })
end

-- ── TypeScript / JavaScript (covers Node, React, Next) ──
lspconfig.ts_ls.setup({ capabilities = capabilities })

-- ── C# (OmniSharp) ──────────────────────────────────────
lspconfig.omnisharp.setup({
  capabilities = capabilities,
  settings = {
    FormattingOptions = { EnableEditorConfigSupport = true },
    RoslynExtensionsOptions = { EnableAnalyzersSupport = true },
  },
})

-- ── Go ───────────────────────────────────────────────────
lspconfig.gopls.setup({
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow       = true,
      },
      staticcheck = true,
      gofumpt     = true,
    },
  },
})

-- ── JSON (with SchemaStore for package.json, tsconfig, etc.) ─
local schemastore_ok, schemastore = pcall(require, "schemastore")
lspconfig.jsonls.setup({
  capabilities = capabilities,
  settings = {
    json = {
      schemas  = schemastore_ok and schemastore.json.schemas() or {},
      validate = { enable = true },
    },
  },
})

-- ── YAML (with SchemaStore for docker-compose, CI/CD, k8s) ──
lspconfig.yamlls.setup({
  capabilities = capabilities,
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" }, -- use schemastore.nvim instead
      schemas     = schemastore_ok and schemastore.yaml.schemas() or {},
      validate    = true,
    },
  },
})

-- ── Lua (configured for Neovim development — recognizes `vim` global) ─
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
