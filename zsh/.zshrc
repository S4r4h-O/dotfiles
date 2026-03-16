# ── PATH ─────────────────────────────────────────────────────
typeset -U path

path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/.cargo/bin"
  "$HOME/Applications"
  "$HOME/.config/spicetify"
  $path
)

# ── XDG Base Dirs ─────────────────────────────────────────────
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# ── Shell ──────────────────────────────────────────────────────
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export EDITOR="nvim"

# ── Tools (XDG compliance) ─────────────────────────────────────
export ANDROID_USER_HOME="$XDG_DATA_HOME/android"
export SPICETIFY_CONFIG="$XDG_CONFIG_HOME/spicetify"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export LIBVIRT_DEFAULT_URI="qemu:///system"

# ── History ──────────────────────────────────────────────────
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=400
SAVEHIST=400

# ── Options ──────────────────────────────────────────────────
setopt autocd extendedglob nomatch

# ── Keybindings ──────────────────────────────────────────────
# bindkey -v
# bindkey -M viins "^[[H" beginning-of-line
# bindkey -M viins "^[[F" end-of-line
# bindkey -M vicmd "^[[H" beginning-of-line
# bindkey -M vicmd "^[[F" end-of-line

# ── Completion styles ─────────────────────────────────────────
# compinit here is superseded by zicompinit in the zinit block below
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' verbose true
zstyle :compinstall filename '$ZDOTDIR/.zshrc'
autoload -Uz compinit
compinit

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
# Fragile, needs more verifications
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
zi snippet OMZL::clipboard.zsh
zi snippet OMZP::aliases
zi snippet OMZP::alias-finder
zi snippet OMZP::extract
zi snippet OMZP::common-aliases
zi snippet OMZP::copyfile
zi snippet OMZP::copypath
zi snippet OMZP::git-commit
zi snippet OMZP::systemd
zi snippet OMZP::command-not-found
zi snippet OMZP::universalarchive
# zi snippet OMZP::profiles
# Development
zi snippet OMZP::uv
zi snippet OMZP::python
# zi snippet OMZP::podman
# zi snippet OMZP::node
# zi snippet OMZP::bun
# zi snippet OMZP::nestjs

case "$(_distro)" in
  arch) zi snippet OMZP::archlinux
  ;;
  fedora) zi snippet OMZP::dnf
  ;;
  ubuntu|debian) zi snippet OMZP::ubuntu
  ;;
esac

# ── Tool initialization ───────────────────────────────────────
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# ── Source ────────────────────────────────────────────────────
source "$ZDOTDIR/aliases.zsh"
source "$HOME/.config/broot/launcher/bash/br"
