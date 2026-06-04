return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      -- c, lua, markdown, markdown_inline, query, vim, vimdoc ship with nvim core
      -- (see /usr/share/nvim/runtime/parser) — managing them here shadows the
      -- bundled parser with a stale .so and breaks queries. Leave them to nvim.
      local parsers = {
        'bash',
        'diff',
        'html',
        'luadoc',
        'regex',
        'javascript',
        'typescript',
      }
      require('nvim-treesitter').install(parsers)

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        if not vim.treesitter.language.add(language) then return end
        vim.treesitter.start(buf, language)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

          if vim.tbl_contains(installed_parsers, language) then
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
          else
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPost',
    opts = {
      trim_scope = 'inner',
      multiline_threshold = 1,
      mode = 'topline',
    },
  },
}
