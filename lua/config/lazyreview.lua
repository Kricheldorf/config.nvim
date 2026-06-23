-- :LazyReview — fetch (no apply) and open a GitHub compare diff per plugin
-- that has pending updates. Lets you eyeball each change before :Lazy update.
--
-- Mechanics: for each managed git plugin, `git fetch` the remote, compare the
-- local HEAD against the branch lazy would check out, and open
-- https://github.com/OWNER/REPO/compare/OLD...NEW in the browser. Nothing is
-- ever checked out — review only.

local M = {}

-- Run git in `dir`, return trimmed stdout or nil on failure.
local function git(dir, args)
  local cmd = { 'git', '-C', dir }
  vim.list_extend(cmd, args)
  local res = vim.system(cmd, { text = true }):wait()
  if res.code ~= 0 then return nil end
  return (res.stdout or ''):gsub('%s+$', '')
end

-- owner/repo base url from a git remote url, github only.
local function github_base(url)
  if not url then return nil end
  local owner_repo = url:match 'github%.com[:/]([^/]+/[^/]+)'
  if not owner_repo then return nil end
  owner_repo = owner_repo:gsub('%.git$', '')
  return 'https://github.com/' .. owner_repo
end

-- short sha helper
local function short(sha) return sha and sha:sub(1, 7) or nil end

-- Fetch all reviewable plugins and resolve their pending target, then call
-- done(updates, skipped, manual). Async; done always fires (incl. empty).
function M.collect(done)
  local ok, cfg = pcall(require, 'lazy.core.config')
  if not ok then
    vim.notify('lazy.nvim not loaded', vim.log.levels.ERROR)
    return done({}, {}, {})
  end
  local lgit = require 'lazy.manage.git'

  -- collect reviewable plugins: managed git repos, not pinned, on disk
  local plugins = {}
  for _, p in pairs(cfg.plugins) do
    local is_local = p._ and p._.is_local
    if p.url and p.dir and not p.pin and not is_local then
      plugins[#plugins + 1] = p
    end
  end

  if #plugins == 0 then return done({}, {}, {}) end

  local pending = #plugins
  local updates = {} -- { name, url, old, new }
  local skipped = {} -- non-github plugins with updates
  local manual = {} -- couldn't resolve target — check by hand

  for _, p in ipairs(plugins) do
    -- fetch tags too so semver (version=) targets resolve to new releases.
    -- on_exit runs in a fast event context; defer the resolution (which uses
    -- :wait() and reads refs) to the main loop via vim.schedule.
    vim.system({ 'git', '-C', p.dir, 'fetch', '--quiet', '--tags', 'origin' }, { text = true }, function()
      vim.schedule(function()
        local old = git(p.dir, { 'rev-parse', 'HEAD' })
        -- ask lazy itself what it would check out (branch / tag / version / commit)
        local tok, target = pcall(lgit.get_target, p)
        local new = tok and target and target.commit or nil
        local label = tok and target and target.tag -- nicer ref for version-pinned

        if old and new and short(old) ~= short(new) then
          local base = github_base(p.url)
          if base then
            local lhs, rhs = short(old), label or short(new)
            updates[#updates + 1] = {
              name = p.name,
              url = ('%s/compare/%s...%s'):format(base, lhs, rhs),
              old = lhs,
              new = label and ('%s (%s)'):format(label, short(new)) or short(new),
            }
          else
            skipped[#skipped + 1] = ('%s (%s..%s)'):format(p.name, short(old), short(new))
          end
        elseif old and not new then
          manual[#manual + 1] = ('%s — could not resolve target'):format(p.name)
        end

        pending = pending - 1
        if pending == 0 then done(updates, skipped, manual) end
      end)
    end)
  end
end

function M.review()
  local ok = pcall(require, 'lazy.core.config')
  if ok then vim.notify 'LazyReview: fetching plugins…' end
  M.collect(function(updates, skipped, manual) M.present(updates, skipped, manual) end)
end

-- Headless entry: `nvim --headless +'lua require("config.lazyreview").print_updates()' +qa`
-- Prints one tab-separated `LRUPDATE\t<name>\t<old>\t<new>` line per pending
-- update so an external tool can grep them. Blocks until fetches complete.
function M.print_updates()
  local done = false
  M.collect(function(updates)
    table.sort(updates, function(a, b) return a.name < b.name end)
    for _, u in ipairs(updates) do
      io.write(('LRUPDATE\t%s\t%s\t%s\n'):format(u.name, u.old, u.new))
    end
    io.flush()
    done = true
  end)
  vim.wait(120000, function() return done end, 100)
end

-- Open a scratch float showing `lines`; line->url map makes <CR> open that
-- plugin's compare page, `o` opens all, `q`/<Esc> closes.
local function show_window(lines, line_url, urls)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'markdown'

  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  width = math.min(math.max(width + 2, 40), vim.o.columns - 4)
  local height = math.min(#lines, vim.o.lines - 6)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' LazyReview ',
    title_pos = 'center',
  })
  vim.wo[win].cursorline = true

  local function close()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end
  local function map(lhs, fn) vim.keymap.set('n', lhs, fn, { buffer = buf, nowait = true, silent = true }) end

  map('q', close)
  map('<Esc>', close)
  map('<CR>', function()
    local url = line_url[vim.api.nvim_win_get_cursor(win)[1]]
    if url then vim.ui.open(url) end
  end)
  map('o', function()
    for _, u in ipairs(urls) do
      vim.ui.open(u)
    end
  end)
end

-- Show the result; let the user open compare urls from the window.
function M.present(updates, skipped, manual)
  manual = manual or {}
  if #updates == 0 and #skipped == 0 and #manual == 0 then
    vim.notify('LazyReview: everything up to date ✔', vim.log.levels.INFO)
    return
  end

  table.sort(updates, function(a, b) return a.name < b.name end)

  local lines = {}
  local line_url = {} -- buffer line number -> compare url
  local urls = {}
  local function add(text, url)
    lines[#lines + 1] = text
    if url then
      line_url[#lines] = url
      urls[#urls + 1] = url
    end
  end

  add(('%d plugin(s) with updates  —  <CR> open  ·  o open all  ·  q close'):format(#updates))
  add ''
  for _, u in ipairs(updates) do
    add(('  • %s   %s → %s'):format(u.name, u.old, u.new), u.url)
  end
  for _, s in ipairs(skipped) do
    add('  • ' .. s .. '   (non-github, no compare url)')
  end
  if #manual > 0 then
    add ''
    add(('check manually on :Lazy update (%d):'):format(#manual))
    for _, m in ipairs(manual) do
      add('  • ' .. m)
    end
  end
  add ''
  add 'After review: :Lazy update to apply.'

  show_window(lines, line_url, urls)
end

vim.api.nvim_create_user_command('LazyReview', M.review, { desc = 'Fetch plugin updates and open compare diffs (no apply)' })

return M
