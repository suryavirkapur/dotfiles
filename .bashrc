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
alias gx='git add . && git commit -m  "x" && git push'
PS1='[\[\e[38;5;248;2m\]\T\[\e[0m\]] \[\e[48;5;67;1m\]\u\[\e[0m\] (\[\e[38;5;81m\]\w\[\e[0m\]) \[\e[2m\]\$\[\e[0m\] '

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"

export PATH=$HOME/.local/bin:$PATH


alias dot='/usr/bin/git --git-dir=/home/svk/.config/dotfiles --work-tree=$HOME'

export SSH_ASKPASS="$HOME/.local/bin/askpass.sh"
export SUDO_ASKPASS="$HOME/.local/bin/askpass.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/svk/google-cloud-sdk/path.bash.inc' ]; then . '/home/svk/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/svk/google-cloud-sdk/completion.bash.inc' ]; then . '/home/svk/google-cloud-sdk/completion.bash.inc'; fi

cc() {
    # Check if argument is provided
    if [ -z "$1" ]; then
        echo "Usage: cc <filename.cc> [executable_name]"
        echo "Example: cc main.cc"
        echo "Example: cc main.cc myprogram"
        return 1
    fi

    local filename="$1"
    local executable_name="${2:-exe}"

    # Check if file exists
    if [ ! -f "$filename" ]; then
        echo "Error: File '$filename' not found"
        return 1
    fi

    # Find the best available compiler
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
        echo "Install one of: g++-14, g++-13, g++-12, g++-11, g++, clang++"
        return 1
    fi

    echo "Compiling $filename with $compiler..."

    local std_flag="-std=c++17"
    if [ "$compiler" = "clang++" ]; then
        # Check if clang supports C++17
        if ! "$compiler" -std=c++17 -E - < /dev/null >/dev/null 2>&1; then
            std_flag="-std=c++14"
        fi
    fi

    "$compiler" "$std_flag" -O2 -Wall -Wextra -pedantic "$filename" -o "$executable_name"

    if [ $? -eq 0 ]; then
        echo "Compilation successful. Running $executable_name..."
        echo "----------------------------------------"


        "./$executable_name"
        local exit_code=$?

        echo "----------------------------------------"
        echo "Program exited with code: $exit_code"


        rm -f "$executable_name"
        echo "Cleaned up executable file."

        return $exit_code
    else
        echo "Compilation failed."
        rm -f "$executable_name" 2>/dev/null
        return 1
    fi
}


# Function to kill a process running on a specific TCP port
killport() {
    if [ -z "$1" ]; then
        echo "Usage: killport <port_number>"
    else
        echo "Killing process on TCP port: $1"
        sudo fuser -k -n tcp "$1"
    fi
}

. "/home/sk/.deno/env"

export CUDA_PATH="/opt/cuda"
export PATH=$PATH:$CUDA_PATH/bin
export TERMINAL=alacritty

# opencode
export PATH=/home/sk/.opencode/bin:$PATH

# OpenClaw Completion
source "/home/sk/.openclaw/completions/openclaw.bash"
if [ -x "$HOME/.local/bin/mise" ]; then
    eval "$("$HOME/.local/bin/mise" activate bash)"
fi

# OpenFang
export PATH=/home/sk/.openfang/bin:$PATH

# pnpm
export PNPM_HOME="/home/sk/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# mise (toolchain manager)
eval "$(mise activate bash)"

# Prefer mise shims
export PATH="$HOME/.local/share/mise/shims:$PATH"

# dotfiles bare repo helper
# usage: dot status | dot add <file> | dot commit -m "..." | dot push
function dot() {
  git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}
