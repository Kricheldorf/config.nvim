return {
  'bngarren/checkmate.nvim',
  ft = { 'markdown' },
  opts = {
    files = { '*.md' },
    -- Optional: allow a few custom states beyond basic [ ] / [x]
    -- todo_states = {
    --   in_progress = {
    --     marker = '◐',
    --     markdown = '.', -- saved as - [.]
    --     type = 'incomplete',
    --     order = 50,
    --   },
    --   cancelled = {
    --     marker = '✗',
    --     markdown = 'c', -- saved as - [c]
    --     type = 'complete',
    --     order = 2,
    --   },
    -- },

    -- -- Example metadata configuration
    -- metadata = {
    --   started = { enabled = true },
    --   done = { enabled = true },
    --   priority = {
    --     enabled = true,
    --     choices = { 'low', 'medium', 'high' },
    --   },
    -- },
  },
  keys = {
    { '<leader>tt', '<cmd>Checkmate toggle<CR>', desc = 'Toggle todo' },
    -- { '<leader>tn', '<cmd>Checkmate cycle_next<CR>', desc = 'Next todo state' },
    -- { '<leader>tp', '<cmd>Checkmate cycle_previous<CR>', desc = 'Prev todo state' },
    -- { '<leader>ta', '<cmd>Checkmate archive<CR>', desc = 'Archive completed todos' },
    -- -- Metadata helpers
    -- { '<leader>td', '<cmd>Checkmate metadata toggle done<CR>', desc = 'Toggle @done' },
    -- { '<leader>ts', '<cmd>Checkmate metadata toggle started<CR>', desc = 'Toggle @started' },
    -- { '<leader>tP', '<cmd>Checkmate metadata toggle priority<CR>', desc = 'Toggle @priority' },
  },
}
