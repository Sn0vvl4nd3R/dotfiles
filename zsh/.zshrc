export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="foot"
export PYENV_ROOT="$HOME/.pyenv"

typeset -U path PATH
path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$PYENV_ROOT/shims"
  "$PYENV_ROOT/bin"
  "$HOME/.cabal/bin"
  "$HOME/.cargo/bin"
  "$HOME/.local/npm/bin"
  $path
)
export PATH

HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_GLOB
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
unsetopt BEEP
unsetopt CORRECT

autoload -Uz compinit
() {
  local zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  local -a stale_dump
  stale_dump=( $zcompdump(N.mh+24) )
  if [[ ! -f $zcompdump ]] || (( ${#stale_dump} > 0 )); then
    compinit -i -d "$zcompdump"
  else
    compinit -C -d "$zcompdump"
  fi
}

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

bindkey -v
export KEYTIMEOUT=1

bindkey -v '^?' backward-delete-char
bindkey -v '^H' backward-delete-char
bindkey -v '^W' backward-kill-word
bindkey -v '^U' backward-kill-line

zmodload zsh/complist
bindkey -M menuselect '^j' down-line-or-history
bindkey -M menuselect '^k' up-line-or-history
bindkey -M menuselect '^h' backward-char
bindkey -M menuselect '^l' forward-char

setopt PROMPT_SUBST

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes false
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%f '

precmd() {
  vcs_info
}

VIM_MODE="%F{244}[I]%f"

function zle-line-init zle-keymap-select {
  case ${KEYMAP} in
    vicmd)
      VIM_MODE="%B%F{1}[N]%f%b"
      print -n "\e[2 q"
      ;;
    main|viins)
      VIM_MODE="%F{244}[I]%f"
      print -n "\e[2 q"
      ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

PROMPT='${VIM_MODE} %B%F{0}%~%f%b${vcs_info_msg_0_}%(?.%F{4}.%F{1}) »%f '

if (( $+commands[fzf] )); then
  if fzf --zsh &>/dev/null; then
    source <(fzf --zsh)
  else
    [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
    [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
  fi
fi

if (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--height=80%
--multi
--border=single
--preview-window=:hidden
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} 2>/dev/null || cat {})) || ([[ -d {} ]] && (eza --tree --color=always {} 2>/dev/null | head -200 || ls -la {}))'
--bind '?:toggle-preview,ctrl-j:down,ctrl-k:up'
--color='light,bg:#ffffff,fg:#212529,bg+:#eaeef2,fg+:#000000,hl:#0969da,hl+:#cf222e,pointer:#0969da,marker:#116329,border:#000000,gutter:#ffffff'
--prompt='> ' --pointer='>' --marker='+'
"

alias grep='grep --color=auto'

if (( $+commands[eza] )); then
  alias ls='eza --icons=never --git --group-directories-first'
  alias ll='eza -lh --icons=never --git --group-directories-first'
  alias la='eza -lha --icons=never --git --group-directories-first'
else
  alias ls='ls --color=auto --group-directories-first'
  alias ll='ls -lh --color=auto'
  alias la='ls -lha --color=auto'
fi

if (( $+commands[bat] )); then
  alias cat='bat --style=plain --paging=never'
  alias catt='bat'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

if (( $+commands[pyenv] )); then
  pyenv() {
    unfunction pyenv
    eval "$(command pyenv init - zsh)"
    if command pyenv commands | grep -q "virtualenv-init"; then
      eval "$(command pyenv virtualenv-init - zsh)"
    fi
    pyenv "$@"
  }
fi

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

for plugin_path in \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh; do
  if [[ -f "$plugin_path" ]]; then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8c959f"
    source "$plugin_path"
    break
  fi
done

for plugin_path in \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  if [[ -f "$plugin_path" ]]; then
    source "$plugin_path"
    break
  fi
done
