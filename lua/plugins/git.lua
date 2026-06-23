return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      signs = {
        delete = { text = '▁', show_count = true },
        topdelete = { text = '▔', show_count = true },
        changedelete = { text = '~', show_count = true },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk('next', { target = 'all' })
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk('prev', { target = 'all' })
          end
        end, { desc = 'Jump to previous git [c]hange' })

        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline' })
        map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'git [b]lame line' })
        map('n', '<leader>hB', gitsigns.blame, { desc = 'git [B]lame buffer' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
        map('n', '<leader>hQ', function() gitsigns.setqflist 'all' end)
        map('n', '<leader>hq', gitsigns.setqflist)
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tw', gitsigns.toggle_word_diff)
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
      end,
    },
  },
  {
    'sindrets/diffview.nvim',
    opts = {},
    keys = {
      {
        '<leader>gc',
        function()
          Snacks.picker.git_log {
            confirm = function(picker, item)
              picker:close()
              vim.cmd.DiffviewOpen(item.commit .. '^!')
            end,
          }
        end,
        desc = 'DiffViewOpen: Open commit diff (only specific commit)',
      },
      {
        '<leader>gC',
        function()
          Snacks.picker.git_log {
            confirm = function(picker, item)
              picker:close()
              vim.cmd('DiffviewOpen ' .. item.commit)
            end,
          }
        end,
        desc = 'DiffViewOpen: Open commit diff to working tree (+ uncommited)',
      },
      {
        '<leader>gm',
        '<cmd>DiffviewOpen main...HEAD<cr>',
        desc = 'DiffViewOpen: Open diff to main',
      },
      {
        '<leader>gM',
        '<cmd>DiffviewOpen main...HEAD --imply-local<cr>',
        desc = 'DiffViewOpen: Open diff to main (+ uncommitted)',
      },
    },
  },
  {
    'folke/snacks.nvim',
    keys = {
      { '<leader>gr', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
      { '<leader>gg', function() Snacks.lazygit.open() end, desc = 'LazyGit Open' },
      { '<leader>gl', function() Snacks.lazygit.log() end, desc = 'LazyGit Log' },
      { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
      { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'LazyGit Log File' },
      { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
      { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },
      { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
      {
        '<leader>gy',
        function()
          Snacks.gitbrowse {
            what = 'permalink',
            branch = 'main',
            open = function(url) vim.fn.setreg('+', url) end,
            notify = false,
          }
          vim.notify 'Yanked git URL to clipboard'
        end,
        mode = { 'n', 'v' },
        desc = 'Git: yank permalink',
      },
      {
        '<leader>gY',
        function()
          Snacks.gitbrowse { what = 'repo', open = function(url) vim.fn.setreg('+', url) end, notify = false }
          vim.notify 'Yanked repo URL to clipboard'
        end,
        desc = 'Git: yank repo URL',
      },
      { '<leader>gb', function() Snacks.gitbrowse() end, mode = { 'n', 'v' }, desc = 'Git: open in browser' },
      { '<leader>gB', function() Snacks.gitbrowse { what = 'repo' } end, desc = 'Git: open repo in browser' },
      { '<leader>gp', function() Snacks.picker.gh_pr() end, desc = 'GitHub Pull Requests (open)' },
      { '<leader>gP', function() Snacks.picker.gh_pr { state = 'all' } end, desc = 'GitHub Pull Requests (all)' },
    },
  },
}
