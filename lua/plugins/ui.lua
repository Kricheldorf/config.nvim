return {
  -- {
  --   'sainnhe/sonokai',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- Optionally configure and load the colorscheme
  --     -- directly inside the plugin declaration.
  --     vim.g.sonokai_enable_italic = true
  --     vim.g.sonokai_style = 'andromeda'
  --     vim.g.sonokai_better_performance = 1
  --     vim.cmd.colorscheme 'sonokai'
  --   end,
  -- },

  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup { style = 'cool' }
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
    event = 'VimEnter',
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
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
      { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
      { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
      { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
      { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
      { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
      { '<leader>bj', '<cmd>BufferLinePick<cr>', desc = 'Pick Buffer' },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = false,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo-tree',
            highlight = 'Directory',
            text_align = 'left',
          },
          {
            filetype = 'snacks_layout_box',
          },
        },
      },
    },
    -- config = function(_, opts)
    --   require('bufferline').setup(opts)
    --   -- Fix bufferline when restoring a session
    --   vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
    --     callback = function()
    --       vim.schedule(function() pcall(nvim_bufferline) end)
    --     end,
    --   })
    -- end,
  },
}
