return {
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'cool',
        colors = {
          bg0 = '#282A36',
          bg1 = '#343746',
          bg2 = '#3a3d4d',
          bg3 = '#44475A',
          bg_d = '#21222C',
        },
      }
      require('onedark').load()
    end,
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>b', group = '[B]uffer' },
        { '<leader>B', group = '[B]uffer Tabs' },
        { '<leader>d', group = '[D]ebug' },
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },

  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
    ---@module 'noice'
    ---@type NoiceConfig
    opts = {
      notify = { enabled = false },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          -- ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },

      -- cmdline = { enabled = true, view = 'cmdline_popup' },
      -- messages = { enabled = true },
      -- popupmenu = { enabled = true },
      -- lsp = {
      --   progress = { enabled = true },
      --   hover = { enabled = true },
      --   signature = { enabled = false },
      --   message = { enabled = false },
      -- },
      -- presets = {
      --   -- bottom_search = true,
      --   command_palette = true,
      --   long_message_to_split = true,
      -- },
    },
  },
}
