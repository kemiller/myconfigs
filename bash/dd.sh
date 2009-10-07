
# Ignore svn directories... unfortuneately, using .svn doesn't work :(
export FIGNORE=svn

export SVNROOT=https://eng.doubledyno.com/svn

export APP=core
export STAGE=qa

alias rgrep="grep -r --include='*.rb'"

export PATH=~/svn/capistrano:~/svn/utils/mac/fmscripts:$PATH

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

function lookup_files() {
	query=`echo $1 | sed 's/./&*/g;'`
	mdfind -onlyin $(project_dir)/app "kMDItemFSName=$query" | tr -s ' \t\r\n'
	mdfind -onlyin $(project_dir)/public "kMDItemFSName=$query" | tr -s ' \t\r\n'
	mdfind -onlyin $(project_dir)/test "kMDItemFSName=$query" | tr -s ' \t\r\n'
}

function mong() {
	(a ; mongrel_rails start -C config/mongrel/development.yml $* )
}

function master_dir () {
	echo "$HOME/main"
}

function project_dir () { 
	echo $(master_dir)/$APP
}

function a () {
	cd $(project_dir)/$1
}

function p () {
	cd $(master_dir)/$1
}

for app in `\ls -1 ~/main`; do 
	alias $app="export APP=$app; a"
done

alias b="git checkout"
complete -o bashdefault -o default -o nospace -F _git_branch b

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
	lu=$(project_dir)/test/legacy/unit
	lf=$(project_dir)/test/legacy/functional
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
	elif [ "$1" = "lf" ]; then
		${RAKE:-rake} test:legacy:functionals
	elif [ "$1" = "lu" ]; then
		${RAKE:-rake} test:legacy:units
	elif [ "$1" = "li" ]; then
		${RAKE:-rake} test:legacy:integration
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

function gd () {
	pushd $RUBYROOT/gems/1.8/gems/$1 || pushd $RUBYROOT/gems/1.9.*/gems/$1 
}

complete -W '`\ls -1 $RUBYROOT/gems/1.8/gems $RUBYROOT/gems/1.9.*/gems`' gd

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
complete -C ~/bin/rake_bash_complete -o default rake
complete -d cd
complete -d pushd
