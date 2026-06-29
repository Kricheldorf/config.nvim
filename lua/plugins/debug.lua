return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'igorlfs/nvim-dap-view',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = {
    -- keys mirror Chrome DevTools debugger controls
    { '<F8>', function() require('dap').continue() end, desc = 'Debug: Start/Continue (Resume)' },
    { '<F10>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F11>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<S-F11>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<F23>', function() require('dap').step_out() end, desc = 'Debug: Step Out (Shift+F11 alias)' }, -- many terminals (kitty) report Shift+F11 as F23
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Conditional Breakpoint' },
    { '<leader>dL', function() require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end, desc = 'Debug: Log Point' },
    { '<leader>dq', function() require('dap').list_breakpoints() end, desc = 'Debug: List Breakpoints (quickfix)' },
    { '<F7>', function() require('dap-view').toggle() end, desc = 'Debug: Toggle DAP View' },
    { '<leader>dr', function() require('dap').repl.open() end, desc = 'Debug: Open REPL' },
    { '<leader>dl', function() require('dap').run_last() end, desc = 'Debug: Run Last' },
    { '<leader>de', function() require('dap.ui.widgets').hover() end, mode = { 'n', 'v' }, desc = 'Debug: Eval under cursor' },
    { '<leader>dc', function() require('dap').run_to_cursor() end, desc = 'Debug: Run to Cursor' },
    { '<leader>dv', function() require('nvim-dap-virtual-text').toggle() end, desc = 'Debug: Toggle Virtual Text' },
  },
  config = function()
    local dap = require 'dap'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = { 'js' },
    }

    require('dap-view').setup {}

    -- inline variable values next to code during a session
    require('nvim-dap-virtual-text').setup {
      commented = true, -- show as a comment so it blends with your colorscheme
    }

    -- prettier gutter signs (replaces default 'B'/'C'/'L'/'R' letters); colors follow the colorscheme
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { link = 'DiagnosticError' }) -- red
    vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { link = 'DiagnosticWarn' }) -- yellow
    vim.api.nvim_set_hl(0, 'DapLogPoint', { link = 'DiagnosticInfo' }) -- blue
    vim.api.nvim_set_hl(0, 'DapStopped', { link = 'DiagnosticOk' }) -- green
    local g = vim.fn.nr2char -- build nerd-font glyphs from codepoints (avoids byte mangling)
    local signs = {
      DapBreakpoint = { text = g(0xf111), texthl = 'DapBreakpoint' }, --  filled circle
      DapBreakpointCondition = { text = g(0xf192), texthl = 'DapBreakpointCondition' }, --  dot-in-circle
      DapBreakpointRejected = { text = g(0xf111), texthl = 'DapBreakpoint' }, -- same as normal: unverified/rejected look identical
      DapLogPoint = { text = g(0xf111), texthl = 'DapLogPoint' }, --  filled circle (blue)
      DapStopped = { text = g(0xf061), texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = 'DapStopped' }, --  arrow-right
    }
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { link = 'Visual' })
    for name, opts in pairs(signs) do
      vim.fn.sign_define(name, opts)
    end

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
          -- Next.js client-side: components/hooks/browser code in shipix-app.
          -- webRoot must point at the app (not monorepo root) so sourcemaps resolve.
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Next client (shipix-app)',
          url = 'http://localhost:3000',
          webRoot = '${workspaceFolder}/apps/shipix-app',
          runtimeExecutable = '/usr/bin/brave', -- Brave is Chromium-based; pwa-chrome drives it fine
          sourceMaps = true,
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
        {
          -- Next.js server-side: RSC, route handlers, server actions, getServerSideProps.
          -- Run dev server with: NODE_OPTIONS='--inspect' npm run start:app:dev
          -- If breakpoints stay unbound, the Next worker is a child process -> use
          -- "Attach to Node process (pick PID)" and pick the next-server PID instead.
          type = 'pwa-node',
          request = 'attach',
          name = 'Next server (shipix-app, prompt port)',
          -- dap evaluates function config values, so prompt for the inspector port at launch
          port = function() return tonumber(vim.fn.input 'Inspector port: ', '9229') end,
          cwd = '${workspaceFolder}/apps/shipix-app',
          sourceMaps = true,
          restart = true,
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
        {
          -- fallback for when the Next worker is a child process and port-attach won't bind:
          -- pick the next-server PID directly (referenced by the server config's comment above).
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to Node process (pick PID)',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
      }
    end
  end,
}
