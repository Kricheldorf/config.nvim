return {
  'nvim-mini/mini.nvim',
  config = function()
    require('mini.basics').setup()

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
    statusline.setup { use_icons = vim.g.have_nerd_font }

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function() return '%2l:%-2v' end
  end,
}
