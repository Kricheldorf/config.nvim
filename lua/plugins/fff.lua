-- Testing fff.nvim (Rust file finder) on <leader><space>.
-- Snacks.picker.smart() previously held this key — disabled in snacks.lua.
return {
  'dmtrKovalenko/fff.nvim',
  -- Only the fff-nvim cdylib (fff.rust) is loaded by nvim; building the whole
  -- workspace pulls fff-core's default `zlob` feature, which needs Zig. Scope to
  -- the plugin crate to skip that dependency.
  build = 'cargo build --release -p fff-nvim',
  opts = {
    prompt_vim_mode = true,
  },
  keys = {
    { '<leader><space>', function() require('fff').find_files() end, desc = 'Find Files (fff)' },
    { '<leader>.', function() require('fff').resume() end, desc = 'Resume fff (repeat)' },
    -- grep namespace: fff takes over <leader>sg / sw; snacks equivalents moved to sG / sW
    { '<leader>sg', function() require('fff').live_grep() end, desc = 'LiFFFe grep' },
    { '<leader>sz', function() require('fff').live_grep { grep = { modes = { 'fuzzy', 'plain' } } } end, desc = 'Live fffuzzy grep' },
    { '<leader>sw', function() require('fff').live_grep { query = vim.fn.expand '<cword>' } end, desc = 'Search current word (fff)' },
  },
}
