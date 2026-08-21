# Move this file to ~/
# ── XDG Base Dirs ─────────────────────────────────────────────
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export TMPDIR="/tmp"

# ── Tools (XDG compliance) ─────────────────────────────────────
export EDITOR="nvim"
export ANDROID_USER_HOME="$XDG_DATA_HOME/android"
export SPICETIFY_CONFIG="$XDG_CONFIG_HOME/spicetify"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"

# ── ENV ──────────────────────────────────────────────────────
export GTK_THEME="catppuccin-macchiato-pink-standard+default"
export LD_PRELOAD=/opt/gtk-nocsd/libgtk-nocsd.so
export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"
export LIBVIRT_DEFAULT_URI="qemu:///system"
export _JAVA_AWT_WM_NONREPARENTING=1

# ── PATH ──────────────────────────────────────────────────────
typeset -U path

path=(
	"$HOME/bin"
	"$HOME/.bun/bin"
	"$HOME/.local/bin"
	"$HOME/.cargo/bin"
	"$HOME/Applications"
	"$HOME/.local/share/go/bin"
	$path
)
