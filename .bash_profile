# text editor
export EDITOR='subl -w'

# path
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# Command Enhancements
# --------------------

# -l long listing, most recent first -G color
alias l='ls -lhGt'
# -l long listing, most recent first -G color with all files
alias la='ls -A -l -G'
# only dot files
alias l.='ls -d .[^.]*'
# goto last dir cd'ed from
alias last='cd -'
# clear and put up directory
alias cl='clear; l'
 # clear
alias c='clear'
# go up file structure
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
# projects folder 
alias proj='cd ~/brent/hosted; l'                               
# current local ip on network
alias localip='ipconfig getifaddr en1'
# bash settings
alias profile='open ~/.bash_profile '

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
 # FUNCS =======================================================================

# go to folder and print directory
function cdl () {
    cd $1; ls -A -l -G
}

# create a .txt file and open it
function note (){
    cd ~/brent/notes
    file=$1
    file+=".notes"
    touch $file
    open $file
}

#get current ip
function ip {
    myip=$(curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+')
    echo -e "${myip}"
}

# create and open that file
function file (){
    touch $1
    open $1
}

# PS1 integration
# not sure where i got this function from, but it kicks ass
# it shows the current branch of git i am in, whenever i enter a project that is using git
__git_ps1 () { 
    local b="$(git symbolic-ref HEAD 2>/dev/null)";
    if [ -n "$b" ]; then
        printf " { %s }" "${b##refs/heads/}";
    fi
}

GIT_PS1_SHOWDIRTYSTATE=true

# bash prompt
PS1='\e[0;33m\n\n\n\w $(__git_ps1)  \n\u @ \h \n\n\e[m'


# Git helper FUNCS =======================================================================

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

function gitstats {
# awesome work from https://github.com/esc/git-stats
# including some modifications
#stats per author
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

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
      . /opt/local/etc/profile.d/bash_completion.sh
fi
