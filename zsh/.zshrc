# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Ensure these directories exist on the system
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"

# This magic line ensures that if a path is already in your $PATH, 
# it won't be added again. No more mile-long PATH strings!
typeset -U path PATH

# Ensure Homebrew's native ARM64 binaries are prioritized
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# fnm
FNM_PATH="/opt/homebrew/opt/fnm/bin"
if [ -d "$FNM_PATH" ]; then
  eval "`fnm env`"
fi

# Added by Antigravity
export PATH="/Users/johnny/.antigravity/antigravity/bin:$PATH"

# Starship
eval "$(starship init zsh)"

# kill test port
# usage: kport 8080
kport() {
  local port=$1
  local pid=$(lsof -t -nP -i:"$port")
  
  if [ -n "$pid" ]; then
    echo "Port $port is occupied by the following PID(s): $pid. Cleaning up..."
    kill -9 $pid
    echo "Cleanup complete!"
  else
    echo "Port $port is currently clear; no process is using it."
  fi
}