return {
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
}
