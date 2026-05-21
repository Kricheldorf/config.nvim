local toggle_key = '<C-,>'

return {
  -- {
  --   'carlos-algms/agentic.nvim',
  --   opts = {
  --     provider = 'claude-agent-acp',
  --   },
  --   keys = {
  --     {
  --       '<C-Escape>',
  --       function() require('agentic').toggle() end,
  --       mode = { 'n', 'v', 'i' },
  --       desc = 'Toggle Agentic Chat',
  --     },
  --     {
  --       "<C-'>",
  --       function() require('agentic').add_selection_or_file_to_context() end,
  --       mode = { 'n', 'v' },
  --       desc = 'Add file or selection to Agentic to Context',
  --     },
  --     {
  --       '<C-c>',
  --       function() require('agentic').stop_generation() end,
  --       mode = { 'n', 'v', 'i' },
  --       desc = 'Stop Agentic generation',
  --     },
  --     {
  --       '<leader>an',
  --       function() require('agentic').new_session() end,
  --       mode = { 'n', 'v' },
  --       desc = 'New Agentic Session',
  --     },
  --     {
  --       '<leader>ar',
  --       function() require('agentic').restore_session() end,
  --       desc = 'Agentic Restore session',
  --       silent = true,
  --       mode = { 'n', 'v' },
  --     },
  --     {
  --       '<leader>ad',
  --       function() require('agentic').add_current_line_diagnostics() end,
  --       desc = 'Add current line diagnostic to Agentic',
  --       mode = { 'n' },
  --     },
  --     {
  --       '<leader>aD',
  --       function() require('agentic').add_buffer_diagnostics() end,
  --       desc = 'Add all buffer diagnostics to Agentic',
  --       mode = { 'n' },
  --     },
  --   },

  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = true,
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { toggle_key, '<cmd>ClaudeCodeFocus<cr>', desc = 'Claude Code', mode = { 'n', 'x' } },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
      { "<C-'>", '<cmd>ClaudeCodeAdd %<cr>', mode = 'n', desc = 'Add current buffer' },
      { "<C-'>", '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
      },
      -- Diff management
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
    opts = {
      -- terminal = {
      --   ---@module "snacks"
      --   ---@type snacks.win.Config|{}
      --   snacks_win_opts = {
      --     position = 'float',
      --     width = 0.9,
      --     height = 0.9,
      --     keys = {
      --       claude_hide = {
      --         toggle_key,
      --         function(self) self:hide() end,
      --         mode = 't',
      --         desc = 'Hide',
      --       },
      --     },
      --   },
      -- },
      terminal = {
        split_width_percentage = 0.50,
        provider = 'snacks',
        -- provider_opts = {
        --   external_terminal_cmd = 'kitty -d $DEFAULT_WORK_DIR -e %s', -- %s is replaced with claude command
        -- },

        ---@module "snacks"
        ---@type snacks.win.Config|{}
        snacks_win_opts = {
          keys = {
            claude_hide = {
              toggle_key,
              function(self) self:hide() end,
              mode = 't',
              desc = 'Hide',
            },
          },
        },
      },
    },
  },
}
