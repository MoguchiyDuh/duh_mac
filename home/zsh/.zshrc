HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
[[ -d $HISTFILE:h ]] || mkdir -p "$HISTFILE:h"
setopt extended_history share_history hist_ignore_all_dups hist_ignore_space hist_reduce_blanks hist_verify
setopt auto_cd interactive_comments no_beep

fpath=(
  "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions"
  /opt/homebrew/share/zsh/site-functions
  /opt/homebrew/share/zsh-completions
  $fpath
)
autoload -Uz compinit
() {
  local dump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
  local -a fresh=($dump(N.mh-24))
  if (( $#fresh )); then
    compinit -C -d "$dump"
  else
    [[ -d $dump:h ]] || mkdir -p "$dump:h"
    compinit -d "$dump"
    [[ -s $dump ]] && touch "$dump" && zcompile "$dump"
  fi
}

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' '+r:|[._-]=* r:|=*' '+l:|=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*:descriptions' format '%F{4}%d%f'
zstyle ':completion:*:messages' format '%F{8}%d%f'
zstyle ':completion:*:warnings' format '%F{1}no matches%f'

bindkey -e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey '^U' backward-kill-line
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char

(( $+commands[fd] )) && export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --exclude .cache --exclude Library'
[[ " $FZF_DEFAULT_OPTS " == *" --color=16 "* ]] || export FZF_DEFAULT_OPTS="--color=16${FZF_DEFAULT_OPTS:+ $FZF_DEFAULT_OPTS}"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
[[ -t 0 ]] && (( $+commands[fzf] )) && source <(fzf --zsh)

eval "$(starship init zsh)"

alias ls='eza --icons --git --header --group-directories-first'
alias la='eza -la --icons --git --header --group-directories-first'
alias lt='eza -T -L 2 --icons --git --group-directories-first'
alias lat='eza -T -L 2 -la --icons --git --group-directories-first'
alias cat='bat -pp'
alias h='history'
alias c='clear'
(( $+commands[lazygit] )) && alias lgit='lazygit'
(( $+commands[lazysql] )) && alias lsql='lazysql'
(( $+commands[lazydocker] )) && alias ldoc='lazydocker'
(( $+commands[opencode] )) && alias oc='opencode'

hc() {
  : >| "$HISTFILE"
  fc -p "$HISTFILE"
}

yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n $cwd && $cwd != $PWD && -d $cwd ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

if [[ -o interactive && -t 0 && -t 1 && $TERM_PROGRAM == ghostty && -z $TMUX && -z $NVIM && $SHLVL == 1 ]]; then
  fastfetch
fi

eval "$(zoxide init zsh)"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
for plugin in /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [[ -r $plugin ]] && source "$plugin"
done
