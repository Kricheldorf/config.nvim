-- Clear highlights on search
vim.keymap.set('n', '<c-[>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-s>', '<cmd>update<CR>')
vim.keymap.set('n', 'zr', '<cmd>restart<CR>')
vim.keymap.set('n', 'zd', '<cmd>AutoSession delete<CR>', { desc = 'Delete AutoSession' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<c-[>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true, desc = 'Term in normal mode and leave to left buffer' })

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Scroll + center
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result cursor centered' })
-- vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result cursor centered' })

-- Diagnostic navigation
vim.keymap.set('n', '<M-j>', function() vim.diagnostic.jump { count = 1, float = true } end, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<M-k>', function() vim.diagnostic.jump { count = -1, float = true } end, { desc = 'Prev diagnostic' })

-- Wrapped line navigation
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })
vim.keymap.set('n', '0', 'g0', { noremap = true })
vim.keymap.set('n', '$', 'g$', { noremap = true })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines without moving cursor' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'moves lines down in visual selection' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'moves lines up in visual selection' })
vim.keymap.set('v', '<', '<gv', { desc = 'Unindent and keep selection' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent and keep selection' })

vim.keymap.set('x', 'p', [["_dP]], { desc = 'Paste over selection without losing yanked text' })

vim.keymap.set('n', '<leader>yr', function()
  local abs = vim.fn.expand '%:p'
  local root = vim.fn.systemlist({ 'git', '-C', vim.fn.expand '%:p:h', 'rev-parse', '--show-toplevel' })[1]
  if vim.v.shell_error == 0 and root and root ~= '' and abs:sub(1, #root) == root then
    vim.fn.setreg('+', abs:sub(#root + 2))
  else
    vim.fn.setreg('+', vim.fn.expand '%:.')
  end
end, { desc = 'Yank git-root-relative path' })
