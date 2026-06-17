-- Testing fff.nvim (Rust file finder) on <leader><space>.
-- Snacks.picker.smart() previously held this key — disabled in snacks.lua.
return {
  'dmtrKovalenko/fff.nvim',
  build = 'cargo build --release',
  opts = {
    prompt_vim_mode = true,
  },
  keys = {
    { '<leader><space>', function() require('fff').find_files() end, desc = 'Find Files (fff)' },
    { '<leader>/', function() require('fff').live_grep() end, desc = 'LiFFFe grep' },
    { '<leader>.', function() require('fff').resume() end, desc = 'Resume fff (repeat)' },
  },
}
