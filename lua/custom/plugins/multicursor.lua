return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  config = function()
    local mc = require 'multicursor-nvim'
    mc.setup()

    local set = vim.keymap.set

    -- ───────────────────────────────────────────────────────────
    -- IdeaVim / vim-multiple-cursors style (primary workflow)
    -- ──────────     ─────────────────────────────────────────────────

    -- <C-n>: add cursor at next occurrence
    set({ 'n', 'x' }, '<C-n>', function() mc.matchAddCursor(1) end)

    -- <C-x>: skip current match, add cursor at next
    set({ 'n', 'x' }, '<C-x>', function() mc.matchSkipCursor(1) end)

    -- <C-p>: skip current match, add cursor at prev
    set({ 'n', 'x' }, '<C-p>', function() mc.matchSkipCursor(-1) end)

    -- <leader><C-n>: cursor at every match in buffer
    set({ 'n', 'x' }, '<leader><C-n>', mc.matchAllAddCursors)

    -- ───────────────────────────────────────────────────────────
    -- Line-based cursors (add cursor above/below)
    -- ───────────────────────────────────────────────────────────

    set({ 'n', 'x' }, '<up>', function() mc.lineAddCursor(-1) end)
    set({ 'n', 'x' }, '<down>', function() mc.lineAddCursor(1) end)
    set({ 'n', 'x' }, '<leader><up>', function() mc.lineSkipCursor(-1) end)
    set({ 'n', 'x' }, '<leader><down>', function() mc.lineSkipCursor(1) end)

    -- ───────────────────────────────────────────────────────────
    -- Mouse support (Ctrl+click to add cursors, VSCode-style)
    -- ───────────────────────────────────────────────────────────

    set('n', '<c-leftmouse>', mc.handleMouse)
    set('n', '<c-leftdrag>', mc.handleMouseDrag)
    set('n', '<c-leftrelease>', mc.handleMouseRelease)

    -- ───────────────────────────────────────────────────────────
    -- Cursor management
    -- ───────────────────────────────────────────────────────────

    -- Toggle cursors on/off (freeze them, move freely, then re-enable)
    set({ 'n', 'x' }, '<c-q>', function()
      if mc.cursorsEnabled() then
        mc.disableCursors()
      else
        mc.addCursor()
      end
    end)

    -- <esc>: re-enable cursors if disabled, else clear them
    set('n', '<esc>', function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
      else
        -- fall through to default <esc>
      end
    end)

    -- Swap main cursor with prev/next
    set({ 'n', 'x' }, '<left>', mc.prevCursor)
    set({ 'n', 'x' }, '<right>', mc.nextCursor)

    -- Delete the main cursor
    set({ 'n', 'x' }, '<leader>x', mc.deleteCursor)

    -- Restore previous cursor set (like Vim's gv but for cursors)
    set('n', '<leader>gv', mc.restoreCursors)

    -- ───────────────────────────────────────────────────────────
    -- Advanced operations
    -- ───────────────────────────────────────────────────────────

    -- Align cursors vertically (pad with spaces)
    set('n', '<leader>a', mc.alignCursors)

    -- Split visual selection by regex into multiple cursors
    -- e.g. select "foo, bar, baz", press S, type ",", get 3 cursors
    set('x', 'S', mc.splitCursors)

    -- Add cursor at every regex match within visual selection
    set('x', 'M', mc.matchCursors)
  end,
}
