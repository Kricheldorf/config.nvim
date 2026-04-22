-- debug utils for nvim config
_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function() Snacks.debug.backtrace() end
if vim.fn.has 'nvim-0.11' == 1 then
  vim._print = function(_, ...) dd(...) end
else
  vim.print = dd
end

-- TODO:
-- setup other.nvim to jump from and to view and edit pages/components counterparts
-- setup other.nvim to jump to page.tsx file
-- figure out how to expand/collapse blocks - maybe use folds?

vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.diagnostics'
require 'config.lazy'
