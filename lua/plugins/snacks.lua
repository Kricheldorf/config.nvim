return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  init = function()
    local set_indent_hl = function()
      vim.api.nvim_set_hl(0, 'SnacksIndentDim', { fg = '#353b45', nocombine = true })
      vim.api.nvim_set_hl(0, 'SnacksIndentScopeDim', { fg = '#454c59', nocombine = true })
    end
    set_indent_hl()
    vim.api.nvim_create_autocmd('ColorScheme', { callback = set_indent_hl })
  end,
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
      win = {
        keys = {
          -- drop laggy default esc map; Ctrl-Q -> normal mode (flow control is off, -ixon)
          term_normal = { '<C-q>', '<cmd>stopinsert<cr>', mode = 't', desc = 'Terminal normal mode' },
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
    indent = {
      enabled = true,
      indent = { hl = 'SnacksIndentDim' },
      scope = { hl = 'SnacksIndentScopeDim', underline = false },
      animate = { enabled = false },
    },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
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
    { '<leader>,', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
    { '<leader>S', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },

    -- <leader><space> reassigned to fff.nvim for testing (see lua/plugins/fff.lua)
    { '<leader>fs', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
    -- powered-up `/`: fuzzy search lines of current buffer
    { '<leader>/', function() Snacks.picker.lines() end, desc = 'Fuzzy Current Buffer' },
    { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History' },
    {
      '<leader>n',
      function()
        Snacks.picker.notifications {
          confirm = function(picker, item)
            picker:close()
            if item then vim.fn.setreg('+', item.item.msg) end
          end,
        }
      end,
      desc = 'Notification History',
    },
    { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss Notifications' },
    { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },

    { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
    { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
    -- <leader>sg reassigned to fff.nvim live_grep (see lua/plugins/fff.lua); snacks grep moved to sG
    { '<leader>sG', function() Snacks.picker.grep() end, desc = 'Grep (snacks)' },
    -- <leader>sw reassigned to fff current-word grep; snacks grep_word moved to sW
    { '<leader>sW', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word (snacks)', mode = { 'n', 'x' } },

    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete Other Buffers' },
    { '<leader>ba', function() Snacks.bufdelete.all() end, desc = 'Delete All Buffers' },

    { '<leader>Bd', '<cmd>tabclose<cr>', desc = 'Delete Tab' },
    { '<leader>Bo', '<cmd>tabonly<cr>', desc = 'Delete Other Tabs' },
    { '<leader>Bn', '<cmd>tabnew<cr>', desc = 'New Tab' },

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
    { '<leader>>', function() Snacks.picker.resume() end, desc = 'Resume picker' },
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
    { '<C-w>m', function() Snacks.zen.zoom() end, desc = 'Zoom pane' },
    { '<C-w><C-m>', function() Snacks.zen.zoom() end, desc = 'Zoom pane' },
    { '<leader>mi', function() Snacks.image.hover() end, desc = 'Image float (hover)' },
  },
  config = function(_, opts)
    require('snacks').setup(opts)

    -- Snacks toggles under `\`, alongside mini.basics option toggles.
    -- Keys here must not collide with mini's set (w s n r l c C d h i b).
    Snacks.toggle.zen():map [[\z]]
    Snacks.toggle.zoom():map [[\m]]
    Snacks.toggle.dim():map [[\D]]
    Snacks.toggle.inlay_hints():map [[\H]]
    Snacks.toggle.treesitter():map [[\t]]
    Snacks.toggle.indent():map [[\g]]
    Snacks.toggle.scroll():map [[\S]]
  end,
}
