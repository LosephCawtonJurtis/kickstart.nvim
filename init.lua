-- STARTERS(things that have to go first)
-- Automatically clear the +q4D73 terminal artifact on startup
vim.api.nvim_create_autocmd("VimEnter", {
callback = function()
    vim.cmd("mod")
    end,
})

--OPTIONS
require("options")

-- AUTO COMMANDS

-- Highlight when yanking (copying) text.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- vim api.nvim_create_autocmd("hl_visual",{
-- callback = function()
--     vim.
--     end,
-- })

-- PLUGINS
require("config.lazy")
