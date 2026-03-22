# ── History ───────────────────────────────────────────────────
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=400
SAVEHIST=400

# ── Options ───────────────────────────────────────────────────
setopt autocd extendedglob nomatch correct

# ── Keybindings ───────────────────────────────────────────────
# bindkey -v
# bindkey -M viins "^[[H" beginning-of-line
# bindkey -M viins "^[[F" end-of-line
# bindkey -M vicmd "^[[H" beginning-of-line
# bindkey -M vicmd "^[[F" end-of-line

# ── Completion styles ─────────────────────────────────────────
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' verbose true

# ── Zinit bootstrap ───────────────────────────────────────────
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ── Functions ─────────────────────────────────────────────────
function _command() {
  local cmd=$1
  (( $+commands[$cmd] )) || return 1
  echo "$commands[$cmd]"
}

function _distro() {
  [[ -f /etc/os-release ]] || return 1
  awk -F= '$1=="ID"{gsub(/"/, "", $2); print $2}' /etc/os-release
}

function gi() { curl -sLw "\n" "https://www.toptal.com/developers/gitignore/api/$@" ;}

# ── Plugins ───────────────────────────────────────────────────
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull"zinit creinstall -q ." \
    zsh-users/zsh-completions

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# ── Snippets ──────────────────────────────────────────────────
zi snippet OMZP::aliases
zi snippet OMZP::alias-finder
zi snippet OMZP::extract
zi snippet OMZP::common-aliases
zi snippet OMZL::clipboard.zsh
zi snippet OMZP::copyfile
zi snippet OMZP::copypath
zi snippet OMZP::git-commit
zi snippet OMZP::systemd
zi snippet OMZP::command-not-found
zi snippet OMZP::universalarchive
zi snippet OMZP::uv
zi snippet OMZP::python
zi snippet OMZP::bun
zi snippet OMZP::nestjs

case "$(_distro)" in
  arch)
    zi snippet OMZP::archlinux
    ;;
  fedora)
    zi snippet OMZP::dnf
    ;;
  ubuntu|debian)
    zi snippet OMZP::ubuntu
    ;;
esac

# ── Tool initialization ───────────────────────────────────────
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# ── Source ────────────────────────────────────────────────────
source "$ZDOTDIR/aliases.zsh"
source "$HOME/.config/broot/launcher/bash/br"
