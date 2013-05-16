# If not running interactively, don't do anything
[ -z "$PS1" ] && return
 
# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth


#---------------
# Some settings
#---------------

# Enable options:
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s mailwarn
shopt -s sourcepath
shopt -s no_empty_cmd_completion  # bash>=2.04 only
shopt -s cmdhist
shopt -s histappend

export HISTIGNORE="&:bg:fg:ll:h"


#-----------------------
# Greeting, motd etc...
#-----------------------

# Define some colors first:
black='\e[0;30m'
BLACK='\e[1;30m'
blue='\e[0;34m'
BLUE='\e[1;34m'
green='\e[0;32m'
GREEN='\e[1;32m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
red='\e[0;31m'
RED='\e[1;31m'
purple='\e[0;35m'
PURPLE='\e[1;35m'
brown='\e[0;33m'
BROWN='\e[1;33m'

NC='\e[0m'              # No Color

function _exit()    # function to run upon exit of shell
{
    echo -e "${RED}Hasta la vista, baby${NC}"
}
trap _exit EXIT


#---------------
# Shell Prompt
#---------------


# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi
 
color_prompt=

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color) color_prompt=yes;;
esac
 
 
if [ "$color_prompt" = yes ]; then
	PS1="${debian_chroot:+($debian_chroot)}[\A] ${green}\u@\h$NC \w \$ "
else 
	PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w\$ "
fi




# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
fi







 # Alias definitions.
 # You may want to put all your additions into a separate file like
 # ~/.bash_aliases, instead of adding them here directly.
 # See /usr/share/doc/bash-doc/examples in the bash-doc package.
 
 if [ -f ~/.bash_aliases ]; then
     . ~/.bash_aliases
 fi
 
 # enable programmable completion features (you don't need to enable
 # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
 # sources /etc/bash.bashrc).
 if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
     . /etc/bash_completion
 fi

