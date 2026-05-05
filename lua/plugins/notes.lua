return {
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    enabled = false,
    ft = 'markdown',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      workspaces = {
        {
          name = 'Brain',
          path = '~/OneDrive/Brain/',
        },
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    mappings = {
      ['gf'] = {
        action = function() return require('obsidian').util.gf_passthrough() end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ['<leader>ch'] = {
        action = function() return require('obsidian').util.toggle_checkbox() end,
        opts = { buffer = true },
      },
      ['<cr>'] = {
        action = function() return require('obsidian').util.smart_action() end,
        opts = { buffer = true, expr = true },
      },
    },
  },

  {
    'bngarren/checkmate.nvim',
    ft = { 'markdown' },
    opts = {
      files = { '*.md' },
    },
  },
}
