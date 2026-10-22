
-- ~/.config/nvim/lua/config/lsp.lua

-- 1. (Optional) Custom global overrides or settings can go here 
-- vim.lsp.config.lua_ls = { ... }

-- 2. Define the servers you want to turn on
local servers = {
  "lua_ls",
  "rust_analyzer",
  "gopls",
  "ts_ls",
}

-- 3. Natively enable them
-- Neovim automatically pairs these names with definitions provided by nvim-lspconfig
for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end
