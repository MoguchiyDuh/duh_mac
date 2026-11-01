# duh_mac

macOS dotfiles. Plain GNU Stow, one Brewfile, no rendering.

## Layout

- `home/<pkg>/` mirrors `$HOME`, stowed with `--no-folding`: `bat`, `fastfetch`, `ghostty`, `git` (git, gh, lazygit), `nvim`, `opencode`, `starship`, `theme`, `tmux`, `zsh`.
- `Brewfile` has taps, formulae, casks, cargo and uv tools.
- `bootstrap` handles a fresh install: Command Line Tools, Homebrew, rust toolchain, `brew bundle`, stow, zsh completions, theme, nvim plugins and parsers, tldr.

## Setup

```
xcode-select --install
git clone <repo> ~/duh_mac
~/duh_mac/bootstrap
```

## Daily

```
stow -d ~/duh_mac/home -t ~ --no-folding -R <pkg>   # relink after adding files
stow -d ~/duh_mac/home -t ~ -D <pkg>                # unlink
brew bundle --file ~/duh_mac/Brewfile               # install what is missing
brew bundle dump --file ~/duh_mac/Brewfile --force  # snapshot installed state
```

## Theme

```
duh-theme set <image>    # wallpaper, palette, macOS accent
duh-theme mode dark|light|toggle
duh-theme apply          # regenerate from current state
```

Defaults live in `~/.config/duh/theme.toml` and generated files in `~/.local/state/duh/theme/`. Ghostty, tmux and nvim reload live. Obsidian gets a `matugen` CSS snippet in `~/Documents/codex`; enable it once under Settings → Appearance → CSS snippets.
