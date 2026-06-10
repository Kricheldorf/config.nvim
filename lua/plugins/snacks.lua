return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    ---@type table<string, snacks.win.Config>
    styles = {
      zoom_indicator = {
        text = function() return '󰊓 ' .. vim.api.nvim_eval_statusline('%m %f', { winid = 0 }).str end,
      },
    },
    bigfile = { enabled = true },
    explorer = { enabled = true },
    gitbrowse = { enabled = true },
    terminal = {
      enabled = true,
      bo = {
        filetype = 'snacks_terminal',
      },
      wo = {},
      stack = true, -- when enabled, multiple split windows with the same position will be stacked together (useful for terminals)
      keys = {
        q = 'hide',
        gf = function(self)
          local f = vim.fn.findfile(vim.fn.expand '<cfile>', '**')
          if f == '' then
            Snacks.notify.warn 'No file under cursor'
          else
            self:hide()
            vim.schedule(function() vim.cmd('e ' .. f) end)
          end
        end,
        term_normal = {
          '<esc>',
          function(self)
            self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
            if self.esc_timer:is_active() then
              self.esc_timer:stop()
              vim.cmd 'stopinsert'
            else
              self.esc_timer:start(200, 0, function() end)
              return '<esc>'
            end
          end,
          mode = 't',
          expr = true,
          desc = 'Double escape to normal mode',
        },
      },
    },
    image = {
      enabled = true,
      doc = {
        inline = true,
        float = true,
        max_width = 120,
        max_height = 60,
      },
    },
    zen = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    quickfile = { enabled = true },
    rename = { enabled = true },
    scratch = { enabled = true },
    toggle = { enabled = true },
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            -- ['<esc>'] = { 'close', mode = { 'n', 'i' } },
            -- ['<c-[>'] = { '<esc>', mode = 'i', expr = true },
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

    { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
    { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' } },

    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete Other Buffers' },
    { '<leader>ba', function() Snacks.bufdelete.all() end, desc = 'Delete All Buffers' },

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
    { '<c-/>', function() Snacks.terminal() end, mode = { 'n', 't' }, desc = 'Toggle Terminal' },
    { '<c-_>', function() Snacks.terminal() end, mode = { 'n', 't' }, desc = 'which_key_ignore' },
    {
      '<leader>N',
      desc = 'Neovim News',
      function()
        Snacks.win {
          file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'yes',
            statuscolumn = ' ',
            conceallevel = 3,
          },
        }
      end,
    },
    { '<leader>wf', function() Snacks.zen.zoom() end, desc = 'Zoom pane' },
    { '<leader>mi', function() Snacks.image.hover() end, desc = 'Image float (hover)' },
  },
}
