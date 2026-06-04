return {
  { 'NMAC427/guess-indent.nvim', event = { 'BufReadPre', 'BufNewFile' }, opts = {} },

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

      local oil = require 'oil'
      oil.setup {
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
          ['<C-l>'] = false,
          ['<C-k>'] = false,
          ['<C-j>'] = false,
          ['<M-h>'] = 'actions.select_split',
          gs = {
            callback = function()
              -- get the current directory
              local prefills = { paths = oil.get_current_dir() }

              local grug_far = require 'grug-far'
              -- instance check
              if not grug_far.has_instance 'explorer' then
                grug_far.open {
                  instanceName = 'explorer',
                  prefills = prefills,
                  staticTitle = 'Find and Replace from Explorer',
                }
              else
                grug_far.get_instance('explorer'):open()
                -- updating the prefills without clearing the search and other fields
                grug_far.get_instance('explorer'):update_input_values(prefills, false)
              end
            end,
            desc = 'oil: Search in directory',
          },
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
    event = 'VeryLazy',
    config = function()
      local mc = require 'multicursor-nvim'
      mc.setup()

      local set = vim.keymap.set

      set({ 'n', 'x' }, '<C-n>', function() mc.matchAddCursor(1) end)
      set({ 'n', 'x' }, '<C-S-n>', function() mc.matchSkipCursor(1) end)
      set({ 'n', 'x' }, '<C-S-x>', function() mc.matchSkipCursor(1) end)
      set({ 'n', 'x' }, '<C-p>', function() mc.matchAddCursor(-1) end)
      set({ 'n', 'x' }, '<C-S-p>', function() mc.matchSkipCursor(-1) end)
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
    cmd = 'Other',
    keys = { { '<leader>gt', desc = 'Go to other file' } },
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
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/', '~/Code', '~/.config', '~/dotfiles' },
    },
  },

  {
    'otavioschwanck/arrow.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      require('arrow').setup {
        show_icons = true,
        leader_key = '<C-e>', -- Recommended to be a single key
        buffer_leader_key = '<M-e>', -- Per Buffer Mappings
      }

      -- Jump directly to bookmarked file by index
      for i = 1, 9 do
        vim.keymap.set('n', '<M-' .. i .. '>', function()
          -- if the arrow menu float is focused, close it first so :edit lands in the real window
          if vim.b.arrow_current_mode ~= nil then vim.api.nvim_win_close(0, true) end
          require('arrow.persist').go_to(i)
        end, { desc = 'Arrow go to file ' .. i })
      end
    end,
  },

  {
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    opts = {},
  },

  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      local ls = require 'luasnip'

      require('luasnip.loaders.from_vscode').lazy_load()

      vim.keymap.set({ 'i' }, '<C-K>', function() ls.expand() end, { silent = true })
      vim.keymap.set({ 'i', 's' }, '<C-L>', function() ls.jump(1) end, { silent = true })
      vim.keymap.set({ 'i', 's' }, '<C-J>', function() ls.jump(-1) end, { silent = true })

      vim.keymap.set({ 'i', 's' }, '<C-E>', function()
        if ls.choice_active() then ls.change_choice(1) end
      end, { silent = true })
    end,
  },
}
