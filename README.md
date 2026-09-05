# dotfiles

Managed as a bare git repo with `$HOME` as the work-tree (no stow/symlinks).

## Bootstrap on a new machine

Assumes a fresh Omarchy install already exists — this repo restores config and CLI tooling, not the OS itself.

```sh
git clone --bare https://github.com/MhdFadlyy/dotfiles.git "$HOME/.dotfiles"
dotfiles() { git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"; }
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout   # if this fails because tracked files already exist, back them up first
```

Then add the `dotfiles()` function to `~/.bashrc` (it's also tracked in this repo,
so once checked out it's there for next time).

Install packages (`yay` itself is in `pkglist-pacman.txt`, so it's ready before the AUR line runs):

```sh
sudo pacman -S --needed - < ~/pkglist-pacman.txt
yay -S --needed - < ~/pkglist-aur.txt
```

Materialize the pinned tool-CLI versions (each `~/.local/bin/*` shim would also install its own tool lazily on
first run, but doing it once up front avoids the surprise):

```sh
mise install
```

Two things this repo deliberately does not restore — see `AGENTS.md`'s secrets boundary — do these manually:

```sh
gh auth login   # git's credential helper delegates to gh; no token is ever stored in this repo
# restore or generate an ssh key under ~/.ssh if you need one
```

## Usage

```sh
dotfiles status
dotfiles add ~/.config/foo/bar.conf
dotfiles commit -m "..."
dotfiles push
```

Regenerate the package lists when they drift, then `dotfiles add` the two files:

```sh
comm -23 <(pacman -Qqe | sort) <(pacman -Qqem | sort) > ~/pkglist-pacman.txt
pacman -Qqem | sort > ~/pkglist-aur.txt
```

## Conventions

See `AGENTS.md` for repo-specific rules (what gets tracked, commit style, tool ownership).
