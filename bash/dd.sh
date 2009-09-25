
# Ignore svn directories... unfortuneately, using .svn doesn't work :(
export FIGNORE=svn

export SVNROOT=https://eng.doubledyno.com/svn

export APP=core
export BRANCH=trunk
export STAGE=qa

alias rgrep="grep -r --include='*.rb'"

export PATH=~/svn/capistrano:~/svn/utils/mac/fmscripts:$PATH

function usegit () {
	function master_dir () {
		echo "$HOME/main"
	}
	alias b="git co"
	complete -o bashdefault -o default -o nospace -F _git_branch b
}

function trash () {
	mv $* ~/.Trash
}

alias tf='cd $(project_dir)/test/functional'
alias tlf='cd $(project_dir)/test/legacy/functional'
alias tu='cd $(project_dir)/test/unit'
alias tlu='cd $(project_dir)/test/legacy/unit'
alias cf='cd $(project_dir)/config'
alias db='cd $(project_dir)/db'
alias mg='cd $(project_dir)/db/migrate'
alias fx='cd $(project_dir)/test/fixtures'
alias pt='cd $(project_dir)/test/prototypes'
alias my='mysql -D ms_main_development -u root'
alias cn='$(project_dir)/script/console'

function sw () {
	svn switch $SVNROOT/main/$1
}

function lookup_files() {
	query=`echo $1 | sed 's/./&*/g;'`
	mdfind -onlyin $(project_dir)/app "kMDItemFSName=$query" | tr -s ' \t\r\n'
	mdfind -onlyin $(project_dir)/public "kMDItemFSName=$query" | tr -s ' \t\r\n'
	mdfind -onlyin $(project_dir)/test "kMDItemFSName=$query" | tr -s ' \t\r\n'
}

function mong() {
	(a ; mongrel_rails start -C config/mongrel/development.yml $* )
}

function project_dir () {
	if [ -z "$PROJECT_DIR" ]; then
		echo "$(master_dir)/$APP"
	else
		echo "$PROJECT_DIR/$BRANCH"
	fi
}

function master_dir () {
	if [ -z "$PROJECT_DIR" ]; then
		echo "$HOME/svn/main/$BRANCH"
	else
		echo "$PROJECT_DIR/$BRANCH"
	fi
}

function a () {
	cd $(project_dir)/$1
}

function p () {
	cd $(master_dir)/$1
}

alias shared="export PROJECT_DIR=''; export APP=shared; a"

for app in `\ls -1 ~/svn/main/trunk`; do 
	alias $app="export PROJECT_DIR=''; export APP=$app; a"
done

alias msqa="export PROJECT_DIR=~/svn/msqa; a"

alias sp='export PROJECT_DIR=`pwd`; unset BRANCH'

function trunk () {
	export BRANCH=trunk
	p $*
}

function br () {
	export BRANCH=branches/$1
	p $2
}

alias b="br"

function rel () {
   	export BRANCH=`cd ~/svn/main && \ls -1d releases/*/*-$1`
	p $2
}

function ac () {
	cd $(project_dir)/app/controllers/$1
}
function am () {
	cd $(project_dir)/../shared/app/models/$1
}
function aa () {
	cd $(project_dir)/app/admin/$1
}
function ah () {
	cd $(project_dir)/app/helpers/$1
}

function ts () {
	u=$(project_dir)/test/unit
	f=$(project_dir)/test/functional
	file=`echo $1 | sed 's/.rb$//;'`
	thefile=""

	for i in $u/$1 $u/${1}_test $f/$1 $f/${1}_test $f/${1}_controller_test; do
		#echo "Trying $i"
		if [ -e ${i}.rb ]; then
			thefile=${i}.rb
			break;
		fi
	done
	
	if [ -n "$thefile" ]; then
		rake test:units TEST="$thefile" TESTOPTS="$2 $3 $4"
	elif [ "$1" = "f" ]; then
		rake test:functionals
	elif [ "$1" = "u" ]; then
		rake test:units
	else
		echo "$1 not found"
	fi
}

function mig () {
	name=$1
	(a && ./script/generate migration -g $name && mg && $EDITOR ???_$name.rb)
}

function mod () {
	name=$1
	(a && ./script/generate model -g $name && tu && $EDITOR ${name}_test.rb)
}

function con () {
	name=$1
	shift 1
	(a && ./script/generate controller -c $name "$@" && tf && $EDITOR ${name}_controller_test.rb )
}

function unmigrate() {
	echo "update schema_info set version=$1;" | my
}

function look() {
	(a && find app test config -type f | fgrep -v .svn | xargs grep --color=auto $*)
}

function gd () {
	pushd $RUBYROOT/gems/1.8/gems/$1
}

complete -W '`\ls -1 $RUBYROOT/gems/1.8/gems`' gd

function av () {
  cd $(project_dir)/app/views/$1
}

# These help me manage running multiple gem versions at once easily.  I'll have installed
# whatever new/experimental version I want in ~/.gems, and these functions help me add
# and remove it from the gem path.

function gemup() {
	export GEM_PATH="$HOME/.gems:`gem environment GEM_PATH`"
}

function gemdn() {
	unset GEM_PATH
}

complete -W '`\ls -1 $(project_dir)/app/views`' av
complete -W '`\ls -1 $(project_dir)`' a
complete -W '`\ls -1d $HOME/svn/main/releases/*/????-* | cut -d- -f2`' rel
complete -W '`\ls -1d $HOME/svn/main/branches/* | ruby -nae "puts split(%q(/)).last"`' branch
complete -C ~/bin/rake_bash_complete -o default rake
complete -d cd
complete -d pushd
