# AGENTS.md

Repo-specific rules for this dotfiles repo. Global rules (`~/.claude/CLAUDE.md`) apply unless overridden here.

## Standard

This repo is a bare git repo (`~/.dotfiles`, work-tree `$HOME`, bootstrap in `README.md`) tracking a hand-picked
set of config files, not a snapshot of `$HOME`. Ownership is explicit: a file is "in" this repo because someone
deliberately added it, never because a broad `add` swept it in. This file documents what is actually true today,
not an aspiration.

## Layout

- Tracked set is small and deliberate: root dotfiles (`.bashrc`, `README.md`, this file, `pkglist-pacman.txt`,
  `pkglist-aur.txt`), specific files under `.config/<tool>/` (alacritty, btop, Code, foot, ghostty, git, herdr,
  hypr, kitty, lazygit, mise, nvim, omarchy, starship, tmux, voxtype, ...), `.config/systemd/user/voxtype.service`,
  and the CLI wrapper shims under `.local/bin/`. Nothing outside that list is assumed to be tracked.
- `herdr`'s `config.toml` mirrors the already-tracked `.config/tmux/tmux.conf`; its `session.json`, `*.log`, and
  `.plugins.lock` are state/logs, not config, and stay untracked (denied in `.dotfiles-exclude`).
- `.dotfiles-exclude` denies known noise *inside* directories we already track — e.g. Omarchy's Hyprland-settings
  TUI writes `*.bak.<timestamp>` next to `hypr/*.lua` on every edit, and `omarchy/plugins/*` are installed
  artifacts, not config. It is not the tracking boundary itself: things like `.cache` are simply never `add`ed,
  not excluded by pattern.

## Non-negotiable rules

- Add one file at a time: `dotfiles add <path>`. Never `dotfiles add -A` or add a whole directory speculatively.
- Never track secrets, credentials, or session/cache state. Confirmed untracked and staying that way: `.ssh/`,
  `.claude/.credentials.json`, `.claude.json`, `.config/gh/{config.yml,hosts.yml}`, `~/.pi`, `~/.codex`,
  `~/.copilot`, anything under `.cache`. GitHub auth is delegated to `gh auth git-credential` (set in the tracked
  `.config/git/config`) — never store a token or credential file in this repo.
- Commit messages follow Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, ...).
- Don't hand-edit or track most Omarchy-owned state: `.config/omarchy/{hooks,branding,plugins}` and
  `shell.json` are distro-managed/auto-generated — Omarchy recreates them on its own first run, verified
  byte-identical to its shipped templates. Two exceptions are explicit, single-value personal preferences and
  stay tracked: `.config/omarchy/defaults/agent` (default AI agent) and `.config/omarchy/shell.toml` (bar/font
  overrides). `.config/omarchy/extensions/*.jsonc` is a user-extension point, not distro state — it was never
  covered by this rule and stays tracked. `hypr/*.bak.*` is separately excluded (Omarchy's Hyprland-settings
  TUI backup noise); only the explicit Lua files under `.config/hypr/` (`hyprland.lua`, `bindings.lua`,
  `input.lua`, `looknfeel.lua`, `monitors.lua`, `autostart.lua`, ...) are ours to edit and track.
- Don't hand-edit `~/.local/bin/*` shims (`claude`, `codex`, `gh`, `opencode`, ...) — each follows one shared
  4-line `mise exec` template (`mise use -g --quiet "<tool>" && exec mise x "<tool>" -- "<tool>" "$@"`). Change
  tool versions in `.config/mise/config.toml` (tracked); if the template itself needs to change, update every
  shim together, not just one.

## Tool & package ownership

- OS packages come from `pacman`/`yay`. Installing a package and owning its config are separate: this repo owns
  a config file only if it's explicitly tracked, regardless of how the package got installed.
- `.config/mise/config.toml` (tracked) is the single source of truth for tool-CLI versions (`claude`, `codex`,
  `gh`, `node`, ...). `~/.local/bin/*` shims are derived from it, never edited directly.
- Default AI agent selection (`.config/omarchy/defaults/agent`) and global Claude Code behavior defaults
  (`~/.claude/CLAUDE.md`, e.g. caveman/ponytail defaults) are out of scope for this file — don't duplicate them
  here.
- `~/.agents/skills/*` and `~/.pi/agent/skills/*` are Omarchy-owned symlinks into `/usr/share/omarchy/...`. Never
  track them in this repo, never edit through the symlink.

## Doctor

`~/.local/bin/dotfiles-doctor` is a manual, read-only health check — no timer runs it, since no automation
exists on this machine yet. It checks only contracts this file already states: every `mise`-pinned tool
resolves on `PATH`, `voxtype.service` is enabled and active, and that `herdr`/`voxtype` config stays tracked
per the Layout section above. A new contract earns a check here only when it's first written as a rule
elsewhere in this file — never invent a check this file doesn't already claim.

## Git workflow

Global git conventions this repo relies on — don't change casually: `pull.rebase = true`,
`push.autoSetupRemote = true`, `commit.verbose = true`, `diff.algorithm = histogram`, `colorMoved = plain`,
`mnemonicPrefix = true`, `rerere` enabled.

## Maintaining this file

Keep only durable, hand-verified rules. When a rule is invalidated by a real change (a tool migrates off `mise`,
a second host appears, a secrets manager gets adopted), update this file in the same change.
