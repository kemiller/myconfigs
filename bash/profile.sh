#!/bin/bash # for vim

##
## Shell options
##

shopt -s cdspell

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
BASH_CONFIG_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

## 
## Environment
##

PATH="/usr/local/sbin:$PATH"
PATH="/usr/local/bin:$PATH"
PATH="~/bin:$PATH"
export PATH

export COLORTERM=1 
export GREP_OPTIONS="--color=auto"
export LESS="-rf"
export PAGER="less $LESS"

if [[ `uname -s` == "Darwin" ]]; then
  . $BASH_CONFIG_DIR/mac.sh
else
  EDITOR='vim'
fi

if [[ -f ~/.local-profile ]]; then
  . ~/.local-profile
fi

# Automatic bash completion for MacPorts
if [[ -f /opt/local/etc/bash_completion ]]; then
	. /opt/local/etc/bash_completion
else
	. $BASH_CONFIG_DIR/git-completion.bash
fi

complete -o bashdefault -o default -o nospace -F _git g

. $BASH_CONFIG_DIR/rails.sh

##
## Prompt
##

function my-rvm-prompt() {
  if which rvm-prompt > /dev/null 2>&1; then
    echo " $(rvm-prompt $1)"
  fi
}

function my-git-prompt() {
  if which __git_ps1 > /dev/null 2>&1; then
    __git_ps1 " (%s)"
  fi
}

export GIT_PS1_SHOWDIRTYSTATE=true
#export GIT_PS1_DESCRIBE_STYLE=branch
#export GIT_PS1_SHOWUNTRACKEDFILES=true

export PS1='$(gitprompt=`my-git-prompt`; echo "\[\e]0;\w $gitprompt\007\]\n\[\e[034;1;7m\]\h \w \[\e[0m\] \t${gitprompt}$(my-rvm-prompt u)\n➔ ")'

## 
## Misc
##

alias g='git'
alias ls="ls -CFG"

function shave_and_a_haircut() {
	echo -n 
	sleep 0.3
	echo -n 
	sleep 0.3
	echo -n 
	sleep 0.3
	echo -n 
	sleep 0.6
	echo -n 
	sleep 0.3
	echo -n 
}
	
if [[ -d $HOME/.ec2 ]] ; then source $HOME/.ec2/vars; fi
if [[ -s $HOME/.rvm/scripts/rvm ]] ; then source $HOME/.rvm/scripts/rvm ; fi

