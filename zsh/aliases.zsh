# User
alias re="exec zsh"
alias zshconfig="$EDITOR $ZDOTDIR/.zshrc"
alias zalsedit="$EDITOR $ZDOTDIR/aliases.zsh"
alias defaultapps="$EDITOR $HOME/.config/mimeapps.list"

# lsd aliases
alias ls='lsd'
alias ll='lsd -lh'
alias la='lsd -lah'
alias lt='lsd --tree'
alias l='lsd -l'

# Functions
vact() {
  # "Default value" parameter expansion
  source "${1:-.venv}/bin/activate"
}

copyp() {
  # "Default value" parameter expansion
  wl-copy "$(realpath "${1:-.}")"
}
