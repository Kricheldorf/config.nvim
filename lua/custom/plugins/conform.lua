return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    local conform = require 'conform'
    conform:setup {
      format_on_save = {
        timeout_ms = 500,
        javascript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'fallback' },
        typescript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'fallback' },
        lsp_format = "fallback"
      },
      formatters_by_ft = {
        -- Conform will run the first available formatter
        javascript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'fallback' },
        typescript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'fallback' },
      }
    }
  end,
}
