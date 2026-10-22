return
{
 "neovim/nvim-lspconfig",
 config = function()
    vim.lsp.enable({"ts_ls", "lua_ls"})
 end,
}
