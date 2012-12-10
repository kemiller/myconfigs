#!/bin/bash

#
# Defaults
#

DIR_ABBREVS="a: ac:app/controllers am:app/models aa:app/admin ah:app/helpers"
DIR_ABBREVS="$DIR_ABBREVS tf:test/functional tu:test/unit ti:test/integration"
DIR_ABBREVS="$DIR_ABBREVS db:db mg:db/migrate tc:test/factories lb:lib av:app/views"
DIR_ABBREVS="$DIR_ABBREVS aw:app/workers"

SCRIPT_ABBREVS="ss:server cn:console dbc:dbconsole gen:generate"

# Rails Directory Navigation

function detect_rails_dir() {
  if [[ -f config/boot.rb && ! ( "$(pwd)" =~ /^$PROJECT_DIR/ ) ]]; then
    export PROJECT_DIR="$(pwd)"
    setup_test_completion
  fi
}

function project_dir () { 
  echo $PROJECT_DIR
}

function cd_to_subdir() {
  cd $PROJECT_DIR/$1/$2
}

function abbreviation_complete {
  for pair in $DIR_ABBREVS; do
    shortcut=$(echo $pair | cut -d: -f1)
    if [ "$1" == "$shortcut" ]; then
      longcut=$(echo $pair | cut -d: -f2)
      cd_to_subdir $longcut || return 1
      COMPREPLY=( `find $2* -type d` )
      return
    fi
  done
}

function setup_abbreviations() {

  for pair in $DIR_ABBREVS; do

    shortcut=$(echo $pair | cut -d: -f1)
    longcut=$(echo $pair | cut -d: -f2)

    if [[ -d $(project_dir)/$longcut ]]; then
      alias $shortcut="cd_to_subdir $longcut"
      complete -F abbreviation_complete $shortcut
    fi

  done
}

function smart_bundle() {
  if [[ -f Gemfile ]]; then
    bundle exec $*
  else
    $*
  fi
}

alias rake="smart_bundle rake"
alias rails="smart_bundle rails"

for pair in $SCRIPT_ABBREVS; do
  shortcut=$(echo $pair | cut -d: -f1)
  longcut=$(echo $pair | cut -d: -f2)
  alias $shortcut="smart_bundle rails $longcut"
done

# Single Unit Testing

function ts () {
  u=$(project_dir)/test/unit
  f=$(project_dir)/test/functional
  file=`echo $1 | sed 's/.rb$//;'`
  thefile=""

  for i in $u/$1 $u/${1}_test $f/$1 $f/${1}_test $f/${1}_controller_test; do
    if [ -e ${i}.rb ]; then
      thefile=${i}.rb
      break;
    fi
  done

  if [ -n "$thefile" ]; then
    echo running $thefile
    if [ -n "$LITE_RAILS_TEST" ]; then
      (cd $(project_dir) && ${RAKE:-smart_bundle ruby} "$thefile" $2 $3 $4)
    else
      (cd $(project_dir) && ${RAKE:-smart_bundle rake} test:units TEST="$thefile" TESTOPTS="$2 $3 $4")
    fi
  else
    echo "$1 not found"
  fi
}

function list_ruby_files_in_dir () {
  if [[ -d "$1" ]]; then
    cd "$1" && find * -type f | sed 's/.rb$//;'
  fi
}

function setup_test_completion () {
complete -W "$(list_ruby_files_in_dir $(project_dir)/test/unit) \
  $(list_ruby_files_in_dir $(project_dir)/test/functional)" ts
}


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

setup_abbreviations

if [[ -n "$PROJECT_DIR" ]]; then
  setup_test_completion
fi

