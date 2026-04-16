# Plugin Organization

## Decision Table

| Plugin does...                              | File            |
|---------------------------------------------|-----------------|
| Attaches to LSP / language server / TS help | `lsp.lua`       |
| Autocomplete / snippets                     | `completion.lua` |
| Treesitter parser or TS-based feature       | `treesitter.lua` |
| Colorscheme, statusline, dashboard, notify  | `ui.lua`        |
| Text editing, motion, pairs, file picker    | `editor.lua`    |
| Git anything (blame, diff, PR, link)        | `git.lua`       |
| Test runner/adapter                         | `test.lua`      |
| Debugger / DAP                              | `debug.lua`     |
| Linter / diagnostic UI / quickfix UI        | `problems.lua`  |
| Formatter                                   | `format.lua`    |
| Notes, markdown, todo, obsidian             | `notes.lua`     |
| Fits nowhere / one-off / joke               | `misc.lua`      |

**If unsure: `misc.lua`.** Cheap to move later.

**Escape hatch:** Plugin with >80 lines config -> own `plugins/<name>.lua`.

**File bloat:** If a domain file passes ~200 lines, split it.

## Keymap Namespace Reference (future direction, not enforced)

| Prefix       | Domain               |
|--------------|----------------------|
| `<leader>f`  | find (snacks picker) |
| `<leader>g`  | git                  |
| `<leader>l`  | lsp                  |
| `<leader>d`  | debug / dap          |
| `<leader>t`  | test (neotest)       |
| `<leader>x`  | problems (trouble)   |
| `<leader>c`  | code (format)        |
| `<leader>n`  | notes (obsidian)     |
| `<leader>o`  | oil                  |
| `<leader>s`  | search/replace       |
| `<leader>w`  | window               |
| `<leader>b`  | buffer               |
