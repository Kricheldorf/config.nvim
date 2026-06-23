#!/usr/bin/env bash
# Mechanical red-flag scanner for a pending Neovim plugin update.
# Deterministic gate that runs BEFORE AI judgment — prompt injection in the
# diff cannot suppress these findings. Scans ADDED lines only (the new code).
#
# Usage: nvim-update-scan.sh <plugin-name> <OLD-sha> <NEW-sha|origin>
#   e.g. nvim-update-scan.sh snacks.nvim abc123 def456
#
# Exit 0 = no hits, exit 1 = hits found (review them), exit 2 = usage/repo error.

set -uo pipefail

plugin="${1:-}"
old="${2:-}"
new="${3:-origin}"

if [[ -z "$plugin" || -z "$old" ]]; then
  echo "usage: $0 <plugin-name> <OLD-sha> [NEW-sha|origin]" >&2
  exit 2
fi

repo="$HOME/.local/share/nvim/lazy/$plugin"
if [[ ! -d "$repo/.git" ]]; then
  echo "not a git repo: $repo" >&2
  exit 2
fi

# Resolve NEW: if the given sha isn't present, fall back to fetched origin head.
if ! git -C "$repo" rev-parse --verify --quiet "$new^{commit}" >/dev/null; then
  new="$(git -C "$repo" rev-parse --verify --quiet origin/HEAD 2>/dev/null \
        || git -C "$repo" symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null \
        || echo origin)"
fi

range="${old}..${new}"
hits=0

section() { printf '\n=== %s ===\n' "$1"; }
mark()    { hits=$((hits+1)); }

# --- Provenance: authors in this range ---
section "authors in $range"
git -C "$repo" log "$range" --format='%an <%ae>' 2>/dev/null | sort | uniq -c | sort -rn

# Added lines only, across the whole range, excluding pure deletions.
added() { git -C "$repo" diff "$range" --unified=0 2>/dev/null | grep -E '^\+' | grep -vE '^\+\+\+'; }

# --- Dangerous Lua/VimL/shell tokens in added lines ---
# Word-ish patterns for exec, eval, network, and dynamic-code primitives.
patterns='vim\.fn\.system|systemlist|vim\.loop\.spawn|vim\.uv\.spawn|jobstart|termopen|io\.popen|os\.execute|os\.getenv|\bloadstring\b|\bload\(|\bdofile\b|nvim_exec|luaeval|\beval\b|base64|fromhex|\bcurl\b|\bwget\b|nc -|/dev/tcp|socket\.|http[s]?://|require\(.os.\)'

section "exec / eval / network tokens (added lines)"
if out="$(added | grep -nEi "$patterns")"; then
  echo "$out"
  mark
else
  echo "none"
fi

# --- Non-ASCII / hidden characters in added lines (bidi, zero-width, homoglyph) ---
section "non-ASCII chars in added lines (bidi/zero-width/homoglyph risk)"
if out="$(added | grep -nP '[^\x00-\x7F]')"; then
  echo "$out"
  mark
else
  echo "none"
fi

# --- Build / install / dependency surface touched ---
section "build/install/dependency files changed"
if out="$(git -C "$repo" diff --name-only "$range" 2>/dev/null \
          | grep -Ei '(\.sh$|(^|/)makefile$|(^|/)build($|/)|cargo\.(toml|lock)$|package\.json$|postinstall|(^|/)install\.|\.ya?ml$)')"; then
  echo "$out"
  mark
else
  echo "none"
fi

# --- Diff size sanity ---
section "diff size"
git -C "$repo" diff --shortstat "$range" 2>/dev/null || echo "n/a"

section "RESULT"
if [[ "$hits" -gt 0 ]]; then
  echo "FLAGS: $hits category(ies) hit — explain each before approving."
  exit 1
else
  echo "CLEAN: no mechanical red flags. (Still review behavior/default changes.)"
  exit 0
fi
