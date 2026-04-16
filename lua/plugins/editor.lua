return {
  { 'NMAC427/guess-indent.nvim', opts = {} },

  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "<c-;>", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      CustomOilBar = function()
        local path = vim.fn.expand '%'
        path = path:gsub('oil://', '')
        return '  ' .. vim.fn.fnamemodify(path, ':.')
      end

      require('oil').setup {
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
          ['<C-l>'] = false,
          ['<C-k>'] = false,
          ['<C-j>'] = false,
          ['<M-h>'] = 'actions.select_split',
        },
        win_options = {
          winbar = '%{v:lua.CustomOilBar()}',
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _)
            local folder_skip = { 'dev-tools.locks', 'dune.lock', '_build' }
            return vim.tbl_contains(folder_skip, name)
          end,
        },
      }

      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      vim.keymap.set('n', '<space>-', require('oil').toggle_float)
    end,
  },

  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    config = function()
      local mc = require 'multicursor-nvim'
      mc.setup()

      local set = vim.keymap.set

      set({ 'n', 'x' }, '<C-n>', function() mc.matchAddCursor(1) end)
      set({ 'n', 'x' }, '<C-x>', function() mc.matchSkipCursor(1) end)
      set({ 'n', 'x' }, '<C-p>', function() mc.matchSkipCursor(-1) end)
      set({ 'n', 'x' }, '<leader><C-n>', mc.matchAllAddCursors)

      set({ 'n', 'x' }, '<up>', function() mc.lineAddCursor(-1) end)
      set({ 'n', 'x' }, '<down>', function() mc.lineAddCursor(1) end)
      set({ 'n', 'x' }, '<leader><up>', function() mc.lineSkipCursor(-1) end)
      set({ 'n', 'x' }, '<leader><down>', function() mc.lineSkipCursor(1) end)

      set('n', '<c-leftmouse>', mc.handleMouse)
      set('n', '<c-leftdrag>', mc.handleMouseDrag)
      set('n', '<c-leftrelease>', mc.handleMouseRelease)

      set({ 'n', 'x' }, '<c-q>', function()
        if mc.cursorsEnabled() then
          mc.disableCursors()
        else
          mc.addCursor()
        end
      end)

      set('n', '<esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- fall through to default <esc>
        end
      end)

      set({ 'n', 'x' }, '<left>', mc.prevCursor)
      set({ 'n', 'x' }, '<right>', mc.nextCursor)
      set({ 'n', 'x' }, '<leader>x', mc.deleteCursor)
      set('n', '<leader>gv', mc.restoreCursors)
      set('n', '<leader>a', mc.alignCursors)
      set('x', 'S', mc.splitCursors)
      set('x', 'M', mc.matchCursors)
    end,
  },

  {
    'rgroli/other.nvim',
    config = function()
      require('other-nvim').setup {
        mappings = {
          { pattern = '(.*)%.spec%.ts$', target = '%1.ts' },
          { pattern = '(.*)%.spec%.tsx$', target = '%1.tsx' },
          { pattern = '(.*)%.ts$', target = '%1.spec.ts' },
          { pattern = '(.*)%.tsx$', target = '%1.spec.tsx' },
        },
        style = {
          border = 'solid',
          seperator = '|',
          width = 0.7,
          minHeight = 2,
        },
      }
      vim.keymap.set('n', '<leader>gt', '<cmd>Other<CR>', { noremap = true, silent = true })
    end,
  },

  {
    'rmagatti/auto-session',
    lazy = false,
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/', '~/Code' },
    },
  },

  -- TODO: consider removing — snacks.explorer provides similar functionality via <leader>e
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    lazy = true,
    keys = {
      { '\\\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    ---@module 'neo-tree'
    ---@type neotree.Config
    opts = {
      filesystem = {
        window = {
          mappings = {
            ['\\\\'] = 'close_window',
          },
        },
      },
    },
  },

  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }

      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()

      require('mini.basics').setup()

      require('mini.surround').setup { search_method = 'cover_or_next' }

      require('mini.operators').setup {
        replace = {
          prefix = 'cr',
          reindent_linewise = true,
        },
      }

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },
}
