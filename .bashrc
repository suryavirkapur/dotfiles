#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias l='exa -l -a'
alias ls='exa -l -a'
alias c='clear'
alias g='git'
alias grep='grep --color=auto'
alias podman=docker

alias ag='antigravity'
alias npm=pnpm
alias codex='codex --yolo'
alias pj='cd ~/Projekts'
alias pg='cd ~/Programming'
alias hx='helix'
alias gx='git add . && git commit -m "x" && git push'

PS1='[\[\e[38;5;248;2m\]\T\[\e[0m\]] \[\e[48;5;67;1m\]\u\[\e[0m\] (\[\e[38;5;81m\]\w\[\e[0m\]) \[\e[2m\]\$\[\e[0m\] '

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"

export PATH=$HOME/.local/bin:$PATH

export SSH_ASKPASS="$HOME/.local/bin/askpass.sh"
export SUDO_ASKPASS="$HOME/.local/bin/askpass.sh"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# cargo
export PATH="$PATH:$HOME/.cargo/bin"

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.bash.inc" ]; then . "$HOME/google-cloud-sdk/path.bash.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.bash.inc" ]; then . "$HOME/google-cloud-sdk/completion.bash.inc"; fi

cc() {
    if [ -z "$1" ]; then
        echo "Usage: cc <filename.cc> [executable_name]"
        echo "Example: cc main.cc"
        echo "Example: cc main.cc myprogram"
        return 1
    fi

    local filename="$1"
    local executable_name="${2:-exe}"

    if [ ! -f "$filename" ]; then
        echo "Error: File '$filename' not found"
        return 1
    fi

    local compiler=""
    local compilers=("g++-14" "g++-13" "g++-12" "g++-11" "g++" "clang++")

    for comp in "${compilers[@]}"; do
        if command -v "$comp" >/dev/null 2>&1; then
            compiler="$comp"
            break
        fi
    done

    if [ -z "$compiler" ]; then
        echo "Error: No C++ compiler found"
        return 1
    fi

    echo "Compiling $filename with $compiler..."

    local std_flag="-std=c++17"
    if [ "$compiler" = "clang++" ]; then
        if ! "$compiler" -std=c++17 -E - < /dev/null >/dev/null 2>&1; then
            std_flag="-std=c++14"
        fi
    fi

    "$compiler" "$std_flag" -O2 -Wall -Wextra -pedantic "$filename" -o "$executable_name"

    if [ $? -eq 0 ]; then
        echo "Compilation successful. Running $executable_name..."
        "./$executable_name"
        local exit_code=$?
        rm -f "$executable_name"
        return $exit_code
    else
        echo "Compilation failed."
        rm -f "$executable_name" 2>/dev/null
        return 1
    fi
}

killport() {
    if [ -z "$1" ]; then
        echo "Usage: killport <port_number>"
    else
        echo "Killing process on TCP port: $1"
        sudo fuser -k -n tcp "$1"
    fi
}

. "$HOME/.deno/env"

export CUDA_PATH="/opt/cuda"
export PATH="$PATH:$CUDA_PATH/bin"
export TERMINAL=alacritty

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# OpenClaw Completion
if [ -f "$HOME/.openclaw/completions/openclaw.bash" ]; then
  source "$HOME/.openclaw/completions/openclaw.bash"
fi

# OpenFang
export PATH="$HOME/.openfang/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# mise
if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$(mise activate bash)"
fi
export PATH="$HOME/.local/share/mise/shims:$PATH"

# dotfiles bare repo helper
function dot() {
  git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}
