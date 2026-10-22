return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install {'c', 'lua', 'vim', 'vimdoc', 'query', 'bash', 'rust', 'javascript', 'zig', 'typescript' }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'c', 'lua', 'vim', 'help', 'query', 'sh', 'bash',
        'rust', 'javascript', 'zig', 'typescript',
      },
      callback = function() vim.treesitter.start() end,
    })
  end,
}
--{
--    "nvim-treesitter/nvim-treesitter",
--    config = function()
--           require("nvim-treesitter.configs").setup {
--            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "bash"},
--            auto_install = true,
--            highlight = {
--        enable = true,
--    }
--   }
--end,
--}

