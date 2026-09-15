# AGENTS.md

Rules for working in this repo (`~/.dotfiles`, bare git repo, work-tree is `$HOME`). Global rules in
`~/.claude/CLAUDE.md` still apply unless something here says otherwise.

## What this repo is

Bare git repo tracking a hand-picked set of config files under `$HOME`, not a mirror of `$HOME`. A file is
tracked because someone deliberately added it, never because a broad `add` swept it in.

## Communication style

- Don't just agree. Push back on ideas before supporting them, point out weak spots or bad assumptions first.
  Agree only after actually checking it, and only if you add something new, not just "sounds good."
- No empty praise. If something's fine, say why, don't just say it's great.
- No em dash, anywhere, ever. Use a comma, parens, or split into two sentences instead.
- Don't sound like an AI. No "it's worth noting", no "furthermore", no hedging for the sake of hedging. Write
  like a person who actually knows this repo, not an assistant summarizing it.
- Anything that leaves this device, a git push to GitHub, a PR, a commit message, an issue, must be written
  in English, no matter what language the conversation itself is in.
- All of the above (no em dash, no AI tells) applies to everything generated here, not just chat replies:
  commit messages, code comments, config files, docs. Check before calling something done.

## What's tracked

Root: `.bashrc`, `README.md`, `AGENTS.md`, `pkglist-pacman.txt`, `pkglist-aur.txt`, `.dotfiles-exclude`.

Under `.config/`: `alacritty`, `btop`, `Code/User/settings.json`, `foot`, `ghostty`, `git`, `herdr`, `hypr`,
`kitty`, `lazygit`, `mise`, `nvim`, `omarchy` (partial, see below), `solaar`, `starship.toml`, `tmux`,
`voxtype`, plus `systemd/user/voxtype.service`.

`.local/bin/`: every CLI shim (`claude`, `codex`, `copilot`, `crush`, `gemini`, `gh`, `ghui`, `grok`, `hunk`,
`omp`, `opencode`, `pi`, `playwright`) and `dotfiles-doctor`. Nothing outside this list is assumed tracked,
check with `dotfiles ls-files` before assuming.

## Exclusions and partial dirs

`.dotfiles-exclude` denies noise inside dirs we already track: `*.log`, `node_modules/`, `__pycache__/`,
`.DS_Store`, `*.swp`, plus repo-specific junk (`herdr/*.log`, `herdr/session.json`, `herdr/.plugins.lock`,
`hypr/*.bak.*`). It's not the tracking boundary itself, stuff like `.cache` is just never added, not excluded
by pattern.

Omarchy is mostly distro-owned and regenerates its own files on first run, so we don't hand-edit or track most
of it: `.config/omarchy/{hooks,branding,plugins,themed}` and `shell.json` stay untracked. Two exceptions, both
explicit single-value personal prefs: `.config/omarchy/defaults/agent` and `.config/omarchy/shell.toml`.
`.config/omarchy/extensions/*.jsonc` is a user-extension point, not distro state, so it's tracked too.

`herdr/config.toml` maps the same session/window/pane model as `tmux/tmux.conf` (same prefix key, same feel),
different format because they're different tools. Its `session.json`, `*.log`, `.plugins.lock` are runtime
state, excluded above.

## Non-negotiable rules

- Add one file at a time: `dotfiles add <path>`. Never `dotfiles add -A`, never add a whole directory on spec.
- Never track secrets or session state. Confirmed and staying untracked: `.ssh/`, `.claude/.credentials.json`,
  `.claude.json`, `.config/gh/{config.yml,hosts.yml}`, `~/.pi`, `~/.codex`, `~/.copilot`, anything under
  `.cache`. GitHub auth goes through `gh auth git-credential` (set in tracked `.config/git/config`), never a
  stored token.
- Commit messages: Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, scopes like `feat(hypr):` when it
  helps).
- Don't hand-edit `.local/bin/*` shims. Every one follows the same template:
  ```
  #!/bin/bash
  export MISE_MINIMUM_RELEASE_AGE=0
  mise use -g --quiet "<tool>" || exit 1
  exec mise x "<tool>" -- "<tool>" "$@"
  ```
  Change versions in `.config/mise/config.toml`. If the template itself needs to change, update every shim
  together, not just one.

## Tool and package ownership

- OS packages come from `pacman`/`yay`. Installing a package and tracking its config are separate things, a
  file is only "ours" if it's explicitly tracked, regardless of how the package got there.
- `.config/mise/config.toml` pins exact versions for `claude`, `codex`, `gh`, `node`. Other tools (`opencode`,
  `gemini`, `grok`, `crush`, `pi`, `copilot`, `playwright`, `omp`, `ghui`, `hunk`) aren't pinned there, their
  shims resolve through `mise use -g` on first run instead.
- Default AI agent (`.config/omarchy/defaults/agent`) and global Claude Code defaults
  (`~/.claude/CLAUDE.md`, caveman/ponytail etc.) live outside this file, don't duplicate them here.
- `~/.agents/skills/*` and `~/.pi/agent/skills/*` are Omarchy-owned symlinks. Never track them here, never edit
  through the symlink.

## Doctor

`~/.local/bin/dotfiles-doctor` is a manual read-only check, nothing runs it on a timer. It checks exactly three
things this file claims: every `mise`-pinned tool resolves on `PATH`, `voxtype.service` is enabled and active,
and `herdr`/`voxtype` config stays tracked. A new check only gets added here once the matching rule exists
above, never invent one.

## Git workflow

Global git config this repo relies on, don't change it casually: `pull.rebase = true`,
`push.autoSetupRemote = true`, `commit.verbose = true`, `diff.algorithm = histogram`, `colorMoved = plain`,
`mnemonicPrefix = true`, `rerere.enabled = true`.

## Keeping this file honest

Only durable, verified rules go here. When something changes (a tool moves off `mise`, a new machine joins,
secrets move to a manager), update this file in the same change, don't let it drift like the last version did.
