return {
  {
    'nvim-mini/mini.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-mini/mini.extra', version = false },
    },
    config = function()
      require('mini.extra').setup()

      require('mini.basics').setup {
        mappings = {
          windows = true,
        },
      }

      require('mini.ai').setup { n_lines = 500 } -- new useful text objects

      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()

      require('mini.surround').setup { search_method = 'cover_or_next' }

      require('mini.operators').setup {
        replace = {
          prefix = 'cr',
          reindent_linewise = true,
        },
      }

      local statusline = require 'mini.statusline'

      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          -- mini default layout; only change: REC@x indicator
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }

            local rec = vim.fn.reg_recording()
            local macro = rec ~= '' and ('REC @' .. rec) or ''

            local git = MiniStatusline.section_git { trunc_width = 40 }
            local diff = MiniStatusline.section_diff { trunc_width = 75 }
            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
            local filename = MiniStatusline.section_filename { trunc_width = 140 }
            local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }
            local location = '%2l:%-2v'

            return MiniStatusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineModeVisual', strings = { macro } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
              '%<',
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=',
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            }
          end,
        },
      }

      -- refresh statusline so REC@x appears/clears instantly
      vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
        callback = function() vim.cmd.redrawstatus() end,
      })
    end,
  },
}
