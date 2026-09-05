# dotfiles

Managed as a bare git repo with `$HOME` as the work-tree (no stow/symlinks).

## Bootstrap on a new machine

```sh
git clone --bare https://github.com/MhdFadlyy/dotfiles.git "$HOME/.dotfiles"
dotfiles() { git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"; }
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout   # if this fails because tracked files already exist, back them up first
```

Then add the `dotfiles()` function to `~/.bashrc` (it's also tracked in this repo,
so once checked out it's there for next time).

## Usage

```sh
dotfiles status
dotfiles add ~/.config/foo/bar.conf
dotfiles commit -m "..."
dotfiles push
```
