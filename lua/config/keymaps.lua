-- Clear highlights on search
vim.keymap.set('n', '<c-[>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-s>', '<cmd>update<CR>')
vim.keymap.set('n', 'zr', '<cmd>restart<CR>')
vim.keymap.set('n', 'zd', '<cmd>AutoSession delete<CR>', { desc = 'Delete AutoSession' })
-- originally on default nvim keymap ZR is restart, I'm changing to delete AutoSession + restart
vim.keymap.set('n', 'ZR', function()
  vim.cmd 'AutoSession delete'
  vim.cmd 'restart'
end, { desc = 'Delete AutoSession and restart' })

vim.keymap.set('n', 'zs', '<cmd>AutoSession save<CR>', { desc = 'Save session' })
vim.keymap.set('n', 'zS', '<cmd>AutoSession search<CR>', { desc = 'Search/open sessions' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal mode
-- exit to normal via <C-q> (snacks) or builtin <C-\><C-n>; no <Esc> map here so
-- Esc-prefixed sequences (arrows/F-keys) don't stall on timeoutlen
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true, desc = 'Term in normal mode and leave to left buffer' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true, silent = true, desc = 'Term in normal mode and leave to right buffer' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true, desc = 'Term in normal mode and leave to up buffer' })

-- Split navigation
vim.keymap.set({ 'n', 'x' }, '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set({ 'n', 'x' }, '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set({ 'n', 'x' }, '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set({ 'n', 'x' }, '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- <C-w>= : clear winfix on all windows first (snacks/sessions re-pin them), then equalize
vim.keymap.set('n', '<C-w>=', '<cmd>windo set nowinfixwidth nowinfixheight<cr><cmd>wincmd =<cr>', { desc = 'Equalize splits (clear winfix)' })

-- Resize focused split to 75% of screen width (C-/ may arrive as C-_ in terminals)
local function widen_75() vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.75)) end
for _, lhs in ipairs { '<C-w>/', '<C-w><C-/>', '<C-w><C-_>' } do
  vim.keymap.set('n', lhs, widen_75, { desc = 'Focused split to 75% width' })
end

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
