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
alias npm=pnpm
alias pj='cd ~/Projekts'
alias pg='cd ~/Programming'
PS1='[\[\e[38;5;248;2m\]\T\[\e[0m\]] \[\e[48;5;67;1m\]\u\[\e[0m\] (\[\e[38;5;81m\]\w\[\e[0m\]) \[\e[2m\]\$\[\e[0m\] '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/svk/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH=$HOME/.local/bin:$PATH


alias dot='/usr/bin/git --git-dir=/home/svk/.config/dotfiles --work-tree=$HOME'

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:/home/svk/.cargo/bin"

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
