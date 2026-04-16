return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      indent = { enabled = true },
      rename = { enabled = true },
      lazygit = { enabled = true },
      scratch = { enabled = true },
      explorer = { enabled = true },
      picker = {
        enabled = true,
        win = {
          input = {
            keys = {
              ['<c-d>'] = { 'preview_scroll_down', mode = { 'n', 'i' } },
              ['<c-u>'] = { 'preview_scroll_up', mode = { 'n', 'i' } },
              ['<c-f>'] = { 'list_scroll_down', mode = { 'n', 'i' } },
              ['<c-b>'] = { 'list_scroll_up', mode = { 'n', 'i' } },
            },
          },
          list = {
            keys = {
              ['<c-d>'] = 'preview_scroll_down',
              ['<c-u>'] = 'preview_scroll_up',
              ['<c-f>'] = 'list_scroll_down',
              ['<c-b>'] = 'list_scroll_up',
            },
          },
        },
      },
    },
    keys = {
      { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
      { '<leader>S', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },

      { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
      { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep' },
      { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History' },
      { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History' },
      { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },

      { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
      { '<leader>gl', function() Snacks.lazygit.log() end, desc = 'LazyGit Log' },
      { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
      { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'LazyGit Log File' },
      { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
      { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },
      { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },

      { '<leader>gp', function() Snacks.picker.gh_pr() end, desc = 'GitHub Pull Requests (open)' },
      { '<leader>gP', function() Snacks.picker.gh_pr { state = 'all' } end, desc = 'GitHub Pull Requests (all)' },

      { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
      { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
      { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep' },
      { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' } },

      { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' },
      { '<leader>fC', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File' },
      { '<leader>fD', function() Snacks.picker.files { cwd = vim.fn.expand '~/dotfiles' } end, desc = 'Find Dotfile File' },
      { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
      { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },
      { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },

      { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers' },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
      { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
      { '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History' },
      { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands' },
      { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
      { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
      { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages' },
      { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights' },
      { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons' },
      { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
      { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
      { '<leader>sl', function() Snacks.picker.loclist() end, desc = 'Location List' },
      { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },
      { '<leader>sM', function() Snacks.picker.man() end, desc = 'Man Pages' },
      { '<leader>sp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec' },
      { '<leader>sP', function() Snacks.picker.pickers() end, desc = 'Search for pickers' },
      { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
      { '<leader>sr', function() Snacks.picker.resume() end, desc = 'Resume' },
      { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History' },
      { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
    },
  },

  {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      require('onedark').setup { style = 'cool' }
      require('onedark').load()
    end,
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },
}
