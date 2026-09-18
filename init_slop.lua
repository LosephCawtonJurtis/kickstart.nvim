-- ~/.config/nvim/init.lua
-- Light setup for bash/shell scripting
-- Requires: neovim 0.9+, git, a Nerd Font (optional), and a plugin manager (lazy.nvim)

--------------------------------------------------------------------
-- Basic options
--------------------------------------------------------------------
vim.g.mapleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 300
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.clipboard = "unnamedplus"

--------------------------------------------------------------------
-- Bootstrap lazy.nvim
--------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------
require("lazy").setup({

  -- Colorscheme (pick anything you like)
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- LSP support
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "bashls" }, -- bash language server
      })

      local lspconfig = require("lspconfig")
      lspconfig.bashls.setup({})

      -- Basic LSP keymaps (buffer-local, set on attach)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(keys, fn) vim.keymap.set("n", keys, fn, { buffer = ev.buf }) end
          map("gd", vim.lsp.buf.definition)
          map("K", vim.lsp.buf.hover)
          map("<leader>rn", vim.lsp.buf.rename)
          map("<leader>ca", vim.lsp.buf.code_action)
          map("<leader>f", function() vim.lsp.buf.format({ async = true }) end)
        end,
      })
    end,
  },

  -- Treesitter: better syntax highlighting for bash
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "bash", "lua", "vim", "vimdoc" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
      vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
      vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
    end,
  },

  -- Inline diagnostics/linting via shellcheck (through none-ls / null-ls style)
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },
})

--------------------------------------------------------------------
-- Quality-of-life keymaps
--------------------------------------------------------------------
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>t", ":split | terminal<CR>")

-- Make scripts executable automatically on save if they have a shebang
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.sh",
  callback = function()
    local file = vim.fn.expand("%")
    local first_line = vim.fn.getline(1)
    if first_line:match("^#!") then
      vim.fn.system({ "chmod", "+x", file })
    end
  end,
})
