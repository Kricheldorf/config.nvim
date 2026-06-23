local toggle_key = '<C-,>'

return {
  {
    'coder/claudecode.nvim',
    version = '*',
    dependencies = { 'folke/snacks.nvim' },
    config = true,
    cmd = { 'ClaudeCode', 'ClaudeCodeFocus', 'ClaudeCodeSelectModel' },
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      {
        '<leader>aN',
        function() vim.fn.jobstart({ 'kitty', '-d', vim.fn.getcwd(), 'nvim', '-c', 'ClaudeCodeFocus' }, { detach = true }) end,
        desc = 'New nvim+Claude session (kitty)',
      },
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
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
    opts = {
      diff_opts = {
        open_in_new_tab = true,
      },
      terminal = {
        split_width_percentage = 0.50,
        provider = 'snacks',
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
