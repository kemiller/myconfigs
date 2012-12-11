#!/bin/bash

#
# Defaults
#

DIR_ABBREVS="ac:app/controllers am:app/models aa:app/admin ah:app/helpers"
DIR_ABBREVS="$DIR_ABBREVS tf:test/functional tu:test/unit ti:test/integration"
DIR_ABBREVS="$DIR_ABBREVS db:db mg:db/migrate tc:test/factories lb:lib av:app/views"
DIR_ABBREVS="$DIR_ABBREVS aw:app/workers"

SCRIPT_ABBREVS="ss:server cn:console dbc:dbconsole gen:generate"

# Rails Directory Navigation


alias rake="rsr bundle rake"
alias rails="rsr bundle rails"

for pair in $SCRIPT_ABBREVS; do
  shortcut=$(echo $pair | cut -d: -f1)
  longcut=$(echo $pair | cut -d: -f2)
  alias $shortcut="rails $longcut"
done

for pair in $DIR_ABBREVS; do

  shortcut=$(echo $pair | cut -d: -f1)
  longcut=$(echo $pair | cut -d: -f2)

  eval "$(rsr alias $shortcut $longcut)"
done

alias ts="rsr test"
complete -C "rsr testlist" ts


# Misc

function gd () {
  pushd $RUBYROOT/gems/1.8/gems/$1
}
complete -W '`\ls -1 $RUBYROOT/gems/1.8/gems`' gd

alias be="bundle exec"
alias bel="bundle exec rails"
alias ber="bundle exec rake"
alias bev="bundle exec vagrant"

alias rgrep="grep -r --include='*.rb'"
alias rack="ack --ruby"

complete -C ~/bin/rake_bash_complete -o default rake

