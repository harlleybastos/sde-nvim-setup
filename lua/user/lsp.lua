-- ~/.config/nvim/lua/user/lsp.lua
-- This module uses the modern vim.lsp.config()/vim.lsp.enable() API, which
-- requires Neovim 0.11+. Guard against older versions so the whole config
-- degrades gracefully instead of throwing E5108 on startup.
if vim.fn.has("nvim-0.11") == 0 then
  vim.schedule(function()
    vim.notify(
      "This config needs Neovim 0.11+. LSP + completion are disabled — please upgrade Neovim.",
      vim.log.levels.WARN,
      { title = "Neovim LSP" }
    )
  end)
  return
end

local mason           = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    "ts_ls", "solargraph", "clangd",
    "html", "cssls", "tailwindcss", "angularls", "emmet_ls",
    "eslint", "biome", "prismals", "jsonls", "yamlls",
    "dockerls", "docker_compose_language_service", "terraformls",
    "lua_ls",
    -- Game / native / graphics
    "cmake",          -- CMakeLists.txt (cmake-language-server)
    "glsl_analyzer",  -- GLSL shaders (OpenGL / Vulkan)
    -- More languages (intellisense)
    "pyright",        -- Python  (needs python3 on PATH)
    "rust_analyzer",  -- Rust    (best with the rust toolchain / rustup)
    "gopls",          -- Go      (Mason installs via `go install` -> needs Go)
    "omnisharp",      -- C#      (needs the .NET runtime to RUN)
  },
  -- We enable + configure every server explicitly below (attaching cmp
  -- capabilities), so disable mason's automatic enable to avoid a second,
  -- capability-less pass.
  automatic_enable = false,
})

-- ── Diagnostics UI (inline errors like VS Code's red squiggles) ─────
vim.diagnostic.config({
  virtual_text  = true,             -- show the message inline after the line
  signs         = true,             -- gutter icons
  underline     = true,
  severity_sort = true,
  float         = { border = "rounded", source = true },
})

-- ── Convenience commands ─────────────────────────────────
-- The modern vim.lsp.config API dropped the old `:LspInfo`/`:LspLog` commands.
-- Re-add friendly aliases so the familiar commands still work.
vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp",
  { desc = "LSP status (alias for :checkhealth vim.lsp)" })
vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd("tabnew " .. vim.lsp.get_log_path())
end, { desc = "Open the LSP log file" })
vim.api.nvim_create_user_command("LspRestart", function()
  for _, c in ipairs(vim.lsp.get_clients()) do vim.lsp.stop_client(c.id) end
  vim.cmd("edit")   -- re-triggers FileType so servers re-attach
end, { desc = "Restart LSP clients for the current buffer" })

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

-- Auto-insert () after accepting a function/method completion (like VS Code).
local autopairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if autopairs_ok then
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

-- ── Capabilities ─────────────────────────────────────────
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ── Breadcrumbs: attach nvim-navic to LSP servers that support symbols ──
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.documentSymbolProvider then
      local navic_ok, navic = pcall(require, "nvim-navic")
      if navic_ok then
        navic.attach(client, args.buf)
        vim.wo.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
      end
    end
  end,
})

-- ── Servidores simples (nova API) ────────────────────────
local simple_servers = {
  "html", "cssls", "tailwindcss", "angularls",
  "emmet_ls", "eslint", "biome", "prismals",
  "solargraph", "dockerls",
  "docker_compose_language_service", "terraformls",
  "ts_ls",
  "cmake",          -- CMakeLists.txt
  "glsl_analyzer",  -- GLSL shaders (OpenGL / Vulkan)
  "pyright",        -- Python
  "rust_analyzer",  -- Rust
}
for _, server in ipairs(simple_servers) do
  vim.lsp.config(server, { capabilities = capabilities })
  vim.lsp.enable(server)
end

-- ── clangd (C / C++ — game engines, OpenGL, Vulkan) ──────
-- offsetEncoding utf-16 avoids the "multiple offset encodings" warning when
-- clangd attaches alongside other clients. clangd needs compile_commands.json
-- (CMake: -DCMAKE_EXPORT_COMPILE_COMMANDS=ON, or use :CMakeGenerate).
local clangd_caps = vim.deepcopy(capabilities)
clangd_caps.offsetEncoding = { "utf-16" }
vim.lsp.config("clangd", {
  capabilities = clangd_caps,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
    fallbackFlags = { "-std=c++20" },
  },
})
vim.lsp.enable("clangd")

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

-- ── C# (OmniSharp) ───────────────────────────────────────
vim.lsp.config("omnisharp", {
  capabilities = capabilities,
  settings = {
    FormattingOptions       = { EnableEditorConfigSupport = true },
    RoslynExtensionsOptions = { EnableAnalyzersSupport = true },
  },
})
vim.lsp.enable("omnisharp")

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
