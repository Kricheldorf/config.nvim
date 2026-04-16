return {
  { 'ThePrimeagen/vim-be-good' },

  {
    'mistweaverco/kulala.nvim',
    ft = { 'http', 'rest' },
    opts = {
      lsp = {
        enable = true,
        formatter = true,
        filetypes = { 'http', 'rest', 'json', 'yaml', 'bruno' },
      },
      global_keymaps = true,
      global_keymaps_prefix = '<leader>r',
      kulala_keymaps_prefix = '',
    },
  },

  {
    'carlos-algms/agentic.nvim',
    opts = {
      provider = 'claude-agent-acp',
    },
    keys = {
      {
        '<C-\\>',
        function() require('agentic').toggle() end,
        mode = { 'n', 'v', 'i' },
        desc = 'Toggle Agentic Chat',
      },
      {
        "<C-'>",
        function() require('agentic').add_selection_or_file_to_context() end,
        mode = { 'n', 'v' },
        desc = 'Add file or selection to Agentic to Context',
      },
      {
        '<C-,>',
        function() require('agentic').new_session() end,
        mode = { 'n', 'v', 'i' },
        desc = 'New Agentic Session',
      },
      {
        '<A-i>r',
        function() require('agentic').restore_session() end,
        desc = 'Agentic Restore session',
        silent = true,
        mode = { 'n', 'v', 'i' },
      },
      {
        '<leader>ad',
        function() require('agentic').add_current_line_diagnostics() end,
        desc = 'Add current line diagnostic to Agentic',
        mode = { 'n' },
      },
      {
        '<leader>aD',
        function() require('agentic').add_buffer_diagnostics() end,
        desc = 'Add all buffer diagnostics to Agentic',
        mode = { 'n' },
      },
    },
  },
}
