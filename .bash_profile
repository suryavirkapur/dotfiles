#
# ~/.bash_profile
#

[[ -f ~/.profile ]] && . ~/.profile

# Load interactive settings
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
