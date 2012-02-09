
## 
## Environment
##

export EDITOR='mvim -v'

if [[ -d /opt ]]; then
  PATH=/opt/local/sbin:$PATH
  PATH=/opt/local/bin:$PATH
  export MANPATH=/opt/local/man:$MANPATH
  export RUBYROOT=/opt/local/lib/ruby
fi

alias gvim="mvim --remote-tab-silent"
alias kicksilver="killall Quicksilver && open -a Quicksilver"
alias bouncewifi="sudo ifconfig en1 down && sudo ifconfig en1 up"

