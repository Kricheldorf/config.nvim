return {
  {
    'mistweaverco/kulala.nvim',
    opts = {
      ui = {
        scratchpad_default_contents = {
          'POST {{base_url}}/orders HTTP/1.1',
          'accept: application/json',
          'content-type: application/json',
          'Authorization: Bearer {{token}}',
          '',
          '{',
          '  "foo": "bar"',
          '}',
        },
      },
      lsp = {
        enable = true,
        formatter = false,
        filetypes = { 'http', 'rest', 'json', 'yaml', 'bruno' },
      },
      global_keymaps = true,
      global_keymaps_prefix = '<leader>r',
      kulala_keymaps_prefix = '',
    },
  },
  -- TODO: Review necessity and usage. Startup time was around 12ms, very impactful if not used
  -- {
  --   'stevearc/overseer.nvim',
  --   ---@module 'overseer'
  --   ---@type overseer.SetupOpts
  --   opts = {},
  -- },
  {
    'tpope/vim-dadbod',
    cmd = { 'DB' },
    dependencies = {
      {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = { 'tpope/vim-dadbod' },
        cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
        init = function()
          vim.g.db_ui_use_nerd_fonts = 1
          vim.g.db_ui_save_location = vim.fn.stdpath 'data' .. '/dadbod_ui'
          vim.g.db_ui_tmp_query_location = vim.fn.stdpath 'data' .. '/dadbod_ui/tmp'
          vim.g.db_ui_execute_on_save = 0
          vim.g.db_ui_win_position = 'left'
          vim.g.db_ui_winwidth = 40
          vim.g.db_ui_use_nvim_notify = 1
        end,
        keys = {
          { '<leader>Du', '<cmd>DBUIToggle<cr>', desc = 'Dadbod UI toggle' },
          { '<leader>Df', '<cmd>DBUIFindBuffer<cr>', desc = 'Dadbod find buffer' },
          { '<leader>Dr', '<cmd>DBUIRenameBuffer<cr>', desc = 'Dadbod rename buffer' },
          { '<leader>Dq', '<cmd>DBUILastQueryInfo<cr>', desc = 'Dadbod last query' },
          { '<leader>Da', '<cmd>DBUIAddConnection<cr>', desc = 'Dadbod add connection' },
        },
      },
      {
        'kristijanhusak/vim-dadbod-completion',
        ft = { 'sql', 'mysql', 'plsql' },
        dependencies = { 'saghen/blink.cmp' },
      },
    },
  },
}
