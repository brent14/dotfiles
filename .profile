# THE START

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi


#
#	Command Enhancements =======================================================================
#
# setup getting vpn ifconfig utun0

# folder movement & structure
alias l='ls -lhtF' 								# -l long listing, most recent first
alias la='ls -AlhtF' 								# -l long listing, most recent first, all files ( include dot )
alias l.='ls -dFA .[^.]*'  								# only dot files
alias cp='cp -iv'                           						# Preferred 'cp' implementation
alias mv='mv -iv'                           						# Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     						# Preferred 'mkdir' implementation

# cpu & memory
# alias topmem='top -l 1 -o rsize | head -20' 					# top memory process
alias psmem='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'	# ps memory process
alias pscpu='ps wwaxr -o pid,stat,%cpu,time,command | head -10'		# ps processor process
# alias topfull='top -l 9999999 -s 10 -o cpu'					# top list all process, refresh 10 seconds

# network
alias netports='sudo lsof -i | grep LISTEN'					# All listening connections


# misc
alias cputime='uptime'								# cpu uptime
alias localip='hostname -I' 							# current local ip on network
alias externalip='dig +short myip.opendns.com @resolver1.opendns.com' 	# external ip
alias reload='source ~/.profile' 						# reload bash profile
alias cronlog='sudo tail -f /var/log/syslog' 			# log from crontab

#
# 	FUNCS =======================================================================
#


# my processcess
 function myproc() {
 	ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ;
}

# find file whose name starts with a given string
function filess () {
	/usr/bin/find . -name "$@"'*' ;
}


# list of open open TCP/IP sockets to the interwebs for current user
lsnet(){
	lsof -i  | awk '{printf("%-14s%-20s%s\n", $10, $1, $9)}' | sort
}


#
# 	Terminal prompt =======================================================================
#


# not sure where i got this function from, but it kicks ass
# it shows the current branch of git i am in, whenever i enter a project that is using git
__git_ps1 () {
	local b="$(git symbolic-ref HEAD 2>/dev/null)";
	if [ -n "$b" ]; then
		printf "* %s" "${b##refs/heads/}";
	fi
}

# bash prompt
GIT_PS1_SHOWDIRTYSTATE=true
PS1='\e[0;33m \n\n\u @ \h\e[m\e[0;34m $(localip)$(externalip) \e[0;33m\@ \n\w\n\e[m\e[0;34m$(__git_ps1)\e[m\n\$ '


#
#	 Git helper FUNCS =======================================================================
#

function removeline(){
	grep -v $1 $2 > tmp && mv tmp $2;
}



# still need to polish this one
# check if git is up to date with remote
function gitcheck(){
	local b="$(git symbolic-ref HEAD 2>/dev/null)";

	if [ -n "$b" ]; then
		git fetch;
		echo * ;
		git status | sed -n 2p;
	fi
}

# get a quick overview for your git repo
function gitinfo() {

	if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
		# print informations
		echo "git repo overview"
		echo "-----------------"
		echo

		# print all remotes and thier details
		for remote in $(git remote show); do
			echo $remote:
			git remote show $remote
			echo
		done

		# print status of working repo
		echo "status:"
		if [ -n "$(git status -s 2> /dev/null)" ]; then
			git status -s
		else
			echo "working directory is clean"
		fi

		# print at least 5 last log entries
		echo
		echo "log:"
		git log -5 --oneline
		echo

		else
		echo "you're currently not in a git repository"

	    fi
}

# search gitlog with grep multiple terms
# recursevily runs git through arguments passed
function gls() {
	search=$(git log --abbrev-commit --format=format:"%C(bold yellow)%d%C(reset)   %C(white)%h%C(reset)   %C(bold cyan)%s%C(reset)%C(bold blue)   %an%C(reset) - %C(bold blue)(%ar)%C(reset)%C(white)%ad%C(reset)" --all)

	if [ $# -eq 0 ]
	then
		printf "###########################\n# no search term provided #\n# example:                #\n# $ gls search git log    #\n###########################"
	else
		for i in "$@"; do
  			search=$(echo "$search" | grep -i $i)
		done
		echo "$search"
	fi
}

# awesome work from https://github.com/esc/git-stats
# including some modifications
# stats per author
function gitstats {

	if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
		echo "Number of commits per author:"
		git --no-pager shortlog -sn --all
		AUTHORS=$( git shortlog -sn --all | cut -f2 | cut -f1 -d' ')
		LOGOPTS=""

	if [ "$1" == '-w' ]; then
		LOGOPTS="$LOGOPTS -w"
		shift
	fi

	if [ "$1" == '-M' ]; then
		LOGOPTS="$LOGOPTS -M"
		shift
	fi

	if [ "$1" == '-C' ]; then
		LOGOPTS="$LOGOPTS -C --find-copies-harder"
		shift
	fi

	for a in $AUTHORS
		do
			echo '-------------------'
			echo "Statistics for: $a"
			echo -n "Number of files changed: "
			git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f3 | sort -iu | wc -l
			echo -n "Number of lines added: "
			git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f1 | awk '{s+=$1} END {print s}'
			echo -n "Number of lines deleted: "
			git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f2 | awk '{s+=$1} END {print s}'
			echo -n "Number of merges: "
			git log $LOGOPTS --all --merges --author=$a | grep -c '^commit'
		done
	else
		echo "you're currently not in a git repository"
	fi
}


#
#	References =======================================================================
#


# https://gist.github.com/natelandau/10654137
# https://github.com/esc/git-stats


# THE END
