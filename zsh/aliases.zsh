# User
alias re="exec zsh"
alias zshconfig="$EDITOR $ZDOTDIR/.zshrc"
alias zalsedit="$EDITOR $ZDOTDIR/aliases.zsh"
alias defaultapps="$EDITOR $HOME/.config/mimeapps.list"
alias tuned="~/Scripts/tuned.sh"
alias r="fc -s"

# lsd aliases
alias ls='lsd'
alias ll='lsd -lh'
alias la='lsd -lah'
alias lt='lsd --tree'
alias l='lsd -l'

# Functions
# TODO: use OMZL::clipboard.zsh?
vact() {
  # "Default value" parameter expansion
  local venv="${1:-.venv}"
  if [[ ! -d ${venv:a} ]]; then
    print -r -- ${(%):-"%B%F{red}${venv:a}%f%b does not exist."} >&2
    return 1
  elif ! source "${venv:a}/bin/activate" 2>/dev/null; then
    print -r -- ${(%):-"%B%F{red}${venv:a}%f%b: failed to activate."} >&2
    return 1
  fi
  print -r -- ${(%):-"%B%F{green}${venv:a}%f%b activated successfully."}
}

copyp() {
  # "Default value" parameter expansion
  local target="${1:-.}"
  if ! print -rn -- "${target:a}" | wl-copy; then
    print -r -- ${(%):-"Failed to copy %B${target:a}%b to clipboard."} >&2
    return 1
  fi
  print -r -- ${(%):-"%B${target:a}%b copied to clipboard."}
}

copyf() {
  for file in "$@"; do
    if ! wl-copy <"${file:a}" 2>&1; then
      printf "Error: could not copy file %s\n" "$file" >&2
      return 1
    fi

    print -r -- ${(%):-"%B${file:a}%b copied to clipboard."}
  done
}

function gi() {
  for g in "$@"; do
    if ! curl -sLw "\n" "https://www.toptal.com/developers/gitignore/api/$g"; then
      echo "Failed to download .gitignore for $g"
      return 1
    fi
  done
}
