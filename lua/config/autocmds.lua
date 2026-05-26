-- Trim spaces lines on lines for md files
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.md',
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.winrestview(save)
  end,
})

-- Setup folding on files when LSP supports foldingRange
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_attach_config', { clear = true }),
  desc = 'Setup on LspAttach',
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method 'textDocument/foldingRange' then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldmethod = 'expr'
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      -- vim.wo[win][0].foldtext = 'v:lua.vim.lsp.foldtext()'
    end
  end,
})

-- FIX: Trigger LSP rename when renaming files/dirs on Oil (double check if it's working)
vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPost',
  callback = function(event)
    if event.data.actions[1].type == 'move' then Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url) end
  end,
})

-- highlight yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  pattern = '*',
  desc = 'highlight selection on yank',
  callback = function() vim.highlight.on_yank { timeout = 200, visual = true } end,
})

-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- defer centering slightly so it's applied after render
      vim.schedule(function() vim.cmd 'normal! zz' end)
    end
  end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  command = 'wincmd L',
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd('VimResized', {
  command = 'wincmd =',
})

-- allow <C-w>= to equalize snacks terminal splits (snacks locks winfix on the split axis)
-- defer because snacks sets winfix in Snacks.util.wo AFTER FileType fires and on a window that
-- doesn't exist yet at FileType time; BufWinEnter + vim.schedule runs after snacks finishes
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('snacks_terminal_winfix', { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].filetype ~= 'snacks_terminal' then return end
    vim.schedule(function()
      for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
        vim.wo[win].winfixwidth = false
      end
    end)
  end,
})

-- -- FIX: no auto continue comments on new line (not working)
-- vim.api.nvim_create_autocmd('FileType', {
--   group = vim.api.nvim_create_augroup('no_auto_comment', {}),
--   callback = function() vim.opt_local.formatoptions:remove { 'c', 'r', 'o' } end,
-- })

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd('BufRead', {
  group = vim.api.nvim_create_augroup('dotenv_ft', { clear = true }),
  pattern = { '.env', '.env.*' },
  callback = function() vim.bo.filetype = 'dosini' end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('active_cursorline', { clear = true }),
  callback = function() vim.opt_local.cursorline = true end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = 'active_cursorline',
  callback = function() vim.opt_local.cursorline = false end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('oil_neotest', { clear = true }),
  pattern = 'oil',
  callback = function()
    vim.keymap.set('n', '<leader>tr', function() require('neotest').run.run(require('oil').get_current_dir()) end, { buffer = true, desc = 'Test oil dir' })
  end,
})
