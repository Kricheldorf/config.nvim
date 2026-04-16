return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'igorlfs/nvim-dap-view',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  keys = {
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Conditional Breakpoint' },
    { '<F7>', function() require('dap-view').toggle() end, desc = 'Debug: Toggle DAP View' },
    { '<leader>dr', function() require('dap').repl.open() end, desc = 'Debug: Open REPL' },
    { '<leader>dl', function() require('dap').run_last() end, desc = 'Debug: Run Last' },
  },
  config = function()
    local dap = require 'dap'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = { 'js' },
    }

    require('dap-view').setup {}

    local function set_debug_keymaps()
      local opts = { silent = true, noremap = true }
      vim.keymap.set('n', '<Down>', function() dap.step_over() end, vim.tbl_extend('force', opts, { desc = 'Debug: Step Over' }))
      vim.keymap.set('n', '<Right>', function() dap.step_into() end, vim.tbl_extend('force', opts, { desc = 'Debug: Step Into' }))
      vim.keymap.set('n', '<Left>', function() dap.step_out() end, vim.tbl_extend('force', opts, { desc = 'Debug: Step Out' }))
      vim.keymap.set('n', '<Up>', function() dap.restart() end, vim.tbl_extend('force', opts, { desc = 'Debug: Restart Frame' }))
    end

    local function del_debug_keymaps()
      vim.keymap.del('n', '<Down>')
      vim.keymap.del('n', '<Right>')
      vim.keymap.del('n', '<Left>')
      vim.keymap.del('n', '<Up>')
    end

    dap.listeners.after.event_initialized['dap-view'] = function()
      require('dap-view').open()
      set_debug_keymaps()
    end
    dap.listeners.before.event_terminated['dap-view'] = function()
      require('dap-view').close()
      del_debug_keymaps()
    end
    dap.listeners.before.event_exited['dap-view'] = function()
      require('dap-view').close()
      del_debug_keymaps()
    end

    local js_debug_path = vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter'
    local js_debug_entrypoint = js_debug_path .. '/js-debug/src/dapDebugServer.js'

    for _, adapter in ipairs { 'pwa-node', 'pwa-chrome' } do
      dap.adapters[adapter] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { js_debug_entrypoint, '${port}' },
        },
      }
    end

    for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to NX/Node (port 9229)',
          port = 9229,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          restart = true,
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to Node process (pick PID)',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch current file (Node)',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch current file (ts-node)',
          runtimeExecutable = 'ts-node',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Jest tests',
          runtimeExecutable = 'node',
          runtimeArgs = { './node_modules/.bin/jest', '--runInBand' },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
        },
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Launch Chrome (localhost:3000)',
          url = 'http://localhost:3000',
          webRoot = '${workspaceFolder}',
        },
      }
    end
  end,
}
