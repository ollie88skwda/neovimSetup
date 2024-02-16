local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")

lspconfig.clangd.setup {
  cmd = { "clangd", "--compile-commands-dir=build" }, -- Adjust the path as necessary
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern('compile_commands.json', 'CMakeLists.txt', 'Makefile'),
}

lspconfig.ccls.setup {
  cmd = { "clangd", "--gcc-toolchain=/usr" },  -- Adjust the path to clangd as needed
  filetypes = { "c", "cpp" },  -- Specify the filetypes for which the language server should be activated
  root_dir = lspconfig.util.root_pattern('.git', 'compile_commands.json', '.ccls'),
  init_options = {
    cache = {
      directory = "ccls-cache"
    },
    compilationDatabaseDirectory = "build",
    gcc = {
      toolchain = "/usr"
    }
  },
}
