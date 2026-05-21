return {
  -- {
  --   'epwalsh/obsidian.nvim',
  --   version = '*',
  --   lazy = true,
  --   enabled = false,
  --   ft = 'markdown',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   opts = {
  --     workspaces = {
  --       {
  --         name = 'Brain',
  --         path = '~/OneDrive/Brain/',
  --       },
  --     },
  --   },
  --   completion = {
  --     nvim_cmp = true,
  --     min_chars = 2,
  --   },
  --   mappings = {
  --     ['gf'] = {
  --       action = function() return require('obsidian').util.gf_passthrough() end,
  --       opts = { noremap = false, expr = true, buffer = true },
  --     },
  --     ['<leader>ch'] = {
  --       action = function() return require('obsidian').util.toggle_checkbox() end,
  --       opts = { buffer = true },
  --     },
  --     ['<cr>'] = {
  --       action = function() return require('obsidian').util.smart_action() end,
  --       opts = { buffer = true, expr = true },
  --     },
  --   },
  -- },

  {
    'bngarren/checkmate.nvim',
    ft = { 'markdown' },
    opts = {
      files = { '*.md' },
    },
  },

  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      default = {
        dir_path = 'assets',
        file_name = '%Y-%m-%d-%H-%M-%S',
        use_absolute_path = false,
        relative_to_current_file = true,
        prompt_for_file_name = false,
      },
    },
    keys = {
      { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from clipboard' },
      {
        '<leader>y',
        function()
          local line = vim.api.nvim_get_current_line()
          -- find path: markdown ](...), wikilink [[...]], or bare image-ext token
          local cfile = line:match '%]%(([^)]+)%)'
            or line:match '%[%[([^%]]+)%]%]'
            or line:match '([%w._/~%-]+%.%a%a%a?%a?)'
          if not cfile then
            vim.notify('no image path found on line', vim.log.levels.WARN)
            return
          end
          -- img-clip writes relative paths; resolve against current file's dir
          local path = cfile
          if not vim.startswith(cfile, '/') then
            path = vim.fs.normalize(vim.fn.expand '%:p:h' .. '/' .. cfile)
          end
          if vim.fn.filereadable(path) == 0 then
            vim.notify('not a readable file: ' .. cfile, vim.log.levels.WARN)
            return
          end
          local mime = vim.fn.systemlist({ 'file', '-b', '--mime-type', path })[1]
          if not (mime and mime:match '^image/') then
            vim.notify('not an image: ' .. cfile, vim.log.levels.WARN)
            return
          end
          local f = assert(io.open(path, 'rb'))
          local data = f:read '*a'
          f:close()
          vim.system({ 'wl-copy', '--type', mime }, { stdin = data, detach = true })
          vim.notify('copied to clipboard: ' .. path)
        end,
        desc = 'Copy image on line to clipboard',
      },
    },
  },
}
