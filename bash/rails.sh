#!/bin/bash

#
# Defaults
#

DIR_ABBREVS="a: ac:app/controllers am:app/models aa:app/admin ah:app/helpers"
DIR_ABBREVS="$DIR_ABBREVS tf:test/functional tu:test/unit ti:test/integration"
DIR_ABBREVS="$DIR_ABBREVS db:db mg:db/migrate tc:test/factories lb:lib av:app/views"

SCRIPT_ABBREVS="ss:server cn:console dbc:dbconsole gen:generate"

# Rails Directory Navigation

function detect_rails_dir() {
  if [[ -f config/boot.rb && ( "$PROJECT_DIR" != "$(pwd)" ) ]]; then
    PROJECT_DIR="$(pwd)"
    setup_abbreviations
  fi
}

function project_dir () { 
  detect_rails_dir
	echo $PROJECT_DIR
}

function cd_to_subdir() {
  cd $(project_dir)/$1/$2
}

function setup_abbreviations() {
  for pair in $DIR_ABBREVS; do
    shortcut=$(echo $pair | cut -d: -f1)
    longcut=$(echo $pair | cut -d: -f2)
    if [[ -d $(project_dir)/$longcut ]]; then
      alias $shortcut="cd_to_subdir $longcut"
      complete -W "$(cd $(project_dir)/$longcut && find * -type d)" $shortcut
    fi
  done
}

# Script Abstraction

function smart_rails_script() {
	if [[ -e script/$1 ]]; then
		script/$*
	elif [[ -e script/rails ]]; then
		rails $*
	fi
}

alias srs="smart_rails_script"

for pair in $SCRIPT_ABBREVS; do
  shortcut=$(echo $pair | cut -d: -f1)
  longcut=$(echo $pair | cut -d: -f2)
  alias $shortcut="(cd $(project_dir) && smart_rails_script $longcut)"
done

# Single Unit Testing

function ts () {
	u=$(project_dir)/test/unit
	f=$(project_dir)/test/functional
	file=`echo $1 | sed 's/.rb$//;'`
	thefile=""

	for i in $u/$1 $u/${1}_test $f/$1 $f/${1}_test $f/${1}_controller_test \
			$lu/$1 $lu/${1}_test $lf/$1 $lf/${1}_test $lf/${1}_controller_test; do
		#echo "Trying $i"
		if [ -e ${i}.rb ]; then
			thefile=${i}.rb
			break;
		fi
	done
	
	if [ -n "$thefile" ]; then
		${RAKE:-rake} test:units TEST="$thefile" TESTOPTS="$2 $3 $4"
	elif [ "$1" = "f" ]; then
		${RAKE:-rake} test:functionals
	elif [ "$1" = "u" ]; then
		${RAKE:-rake} test:units
	elif [ "$1" = "i" ]; then
		${RAKE:-rake} test:integration
	else
		echo "$1 not found"
	fi
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

complete -C ~/bin/rake_bash_complete -o default rake

if [[ -n "$PROJECT_DIR" ]]; then
  setup_abbreviations
fi

