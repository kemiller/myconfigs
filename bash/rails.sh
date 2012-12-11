#!/bin/bash

DIR_ABBREVS="a: ac:app/controllers am:app/models aa:app/admin ah:app/helpers"
DIR_ABBREVS="$DIR_ABBREVS tf:test/functional tu:test/unit ti:test/integration"
DIR_ABBREVS="$DIR_ABBREVS db:db mg:db/migrate tc:test/factories lb:lib av:app/views"
DIR_ABBREVS="$DIR_ABBREVS aw:app/workers"

SCRIPT_ABBREVS="ss:server cn:console dbc:dbconsole gen:generate"

for pair in $SCRIPT_ABBREVS; do
  shortcut=$(echo $pair | cut -d: -f1)
  longcut=$(echo $pair | cut -d: -f2)
  alias $shortcut="rsr bundle rails $longcut"
done

for pair in $DIR_ABBREVS; do
  shortcut=$(echo $pair | cut -d: -f1)
  longcut=$(echo $pair | cut -d: -f2)
  eval "$(rsr alias "$shortcut" "$longcut")"
done

alias a='cd $(rsr path)'
alias rake="rsr bundle rake"
alias rails="rsr bundle rails"
alias vagrant="rsr bundle vagrant"
alias ts="rsr test"
alias rgrep="grep -r --include='*.rb'"
alias rack="ack --ruby"

function gd () {
  pushd $RUBYROOT/gems/1.8/gems/$1
}

complete -W '`\ls -1 $RUBYROOT/gems/1.8/gems`' gd
complete -C "rsr testlist" ts
complete -C ~/bin/rake_bash_complete -o default rake

