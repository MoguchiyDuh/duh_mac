# duh_mac

macOS dotfiles. Plain GNU Stow, one Brewfile, optional metapacks.

## Layout

- `home/<pkg>/` mirrors `$HOME`, stowed with `--no-folding`: `bat`, `fastfetch`, `ghostty`, `git` (git, gh, lazygit), `nvim`, `starship`, `theme`, `tmux`, `zsh`.
- `Brewfile` has the base taps, formulae, casks, cargo and uv tools.
- `meta/<name>/` is a metapack: `Brewfile` plus an optional `home/` tree that gets stowed on top of the base.
- `bootstrap` handles a fresh install: Command Line Tools, Homebrew, rust toolchain, `brew bundle`, stow, zsh completions, theme, nvim plugins and parsers, tldr.

## Setup

```
xcode-select --install
git clone <repo> ~/duh_mac
~/duh_mac/bootstrap
```

## Metapacks

Off by default. `bootstrap` and the base `Brewfile` never pull them in.

```
./metapack list              # name, package count, stowed file count
./metapack opencode show     # what it installs and links
./metapack opencode          # brew bundle install --file meta/opencode/Brewfile, then stow
./metapack opencode remove   # unlink only; packages stay installed
```

| pack | contents |
|---|---|
| `opencode` | `anomalyco/tap/opencode-v2`, plus `~/.config/opencode` (agents, commands, skills, MCP config) and `duh-quota-lookup` |
| `stream` | sunshine host, moonlight client, miniupnpc for router port mapping |

Uninstalling the packages themselves is manual, e.g. `brew uninstall --cask moonlight` and `brew uninstall lizardbyte/homebrew/sunshine`.

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
