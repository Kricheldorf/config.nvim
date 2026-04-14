---@module 'lazy'
---@type LazySpec
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    "antoinemadec/FixCursorHold.nvim",
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-jest',
    -- 'marilari88/neotest-vitest',
  },
  keys = {
    { '<leader>tn', function() require('neotest').run.run() end, desc = 'Test nearest' },
    { '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = 'Test file' },
    { '<leader>tl', function() require('neotest').run.run_last() end, desc = 'Test last' },
    { '<leader>td', function() require('neotest').run.run { strategy = 'dap' } end, desc = 'Debug nearest test' },
    { '<leader>to', function() require('neotest').output.open { enter = true, auto_close = true } end, desc = 'Test output' },
    { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Test output panel' },
    { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Test summary' },
    { '<leader>tS', function() require('neotest').run.stop() end, desc = 'Stop test' },
  },
  config = function()
    local uv = vim.uv or vim.loop

    local function is_file(path)
      local stat = path and uv.fs_stat(path)
      return stat and stat.type == 'file'
    end

    local function is_dir(path)
      local stat = path and uv.fs_stat(path)
      return stat and stat.type == 'directory'
    end

    local function dirname(path)
      if not path or path == '' or path == '/' then return path end
      local stripped = path:gsub('/+$', '')
      local parent = stripped:match '^(.*)/[^/]+$'
      return parent ~= '' and parent or '/'
    end

    local function join(...)
      return table.concat({ ... }, '/')
    end

    local function find_project_root(path)
      local dir = is_dir(path) and path or dirname(path)

      while dir and dir ~= '' do
        if is_file(join(dir, 'package.json')) or is_dir(join(dir, '.git')) then return dir end

        local parent = dirname(dir)
        if parent == dir then break end
        dir = parent
      end

      return uv.cwd()
    end

    local function find_jest_config(path)
      local dir = is_dir(path) and path or dirname(path)
      local configs = {
        'jest.config.ts',
      }

      while dir and dir ~= '' do
        for _, config in ipairs(configs) do
          local config_path = join(dir, config)
          if is_file(config_path) then return config_path end
        end

        local parent = dirname(dir)
        if parent == dir then break end
        dir = parent
      end
    end

    require('neotest').setup {
      adapters = {
        require('neotest-jest') {
          jestCommand = 'npx jest',
          jestConfigFile = function(path) return find_jest_config(path) end,
          cwd = function(path) return find_project_root(path) end,
        },
        -- require('neotest-vitest') {
        --   cwd = function(path) return find_project_root(path) end,
        -- },
      },
    }
  end,
}
