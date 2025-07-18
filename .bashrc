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
PS1='[\u@\h \W]\$ '

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

eval "$(starship init bash)"

alias dot='/usr/bin/git --git-dir=/home/svk/.config/dotfiles --work-tree=$HOME'

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:/home/svk/.cargo/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/svk/google-cloud-sdk/path.bash.inc' ]; then . '/home/svk/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/svk/google-cloud-sdk/completion.bash.inc' ]; then . '/home/svk/google-cloud-sdk/completion.bash.inc'; fi
