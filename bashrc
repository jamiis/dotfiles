# append to the history file, don't overwrite it
shopt -s histappend

# turn on VI mode
set -o vi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# from ubuntu, may be redundant
shopt -s checkwinsize

# the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# from ubuntu, not enabled by default
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    shopt -s globstar
fi

# If this is an xterm set the title to user@host:dir
# from ubuntu, may be redundant
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
# from ubuntu, modified for other OSes, may be redundant
if [ -x "$(which dircolors)" ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
# from ubuntu, may be redundant
alias ll='ls -alhGF'
alias la='ls -AG'
alias l='ls -CFG'



# End ubuntu defaults

PROMPT_COMMAND=_promptcommand
function _promptcommand() {
    for command in "${_PROMPT_COMMANDS[@]}"; do
        eval "$command"
    done
}
function add_prompt_command() {
    _PROMPT_COMMANDS=( "${_PROMPT_COMMANDS[@]}" "$1" );
}

# Go
PATH="/usr/local/go/bin:$PATH"

# set color prompt
function color {
    if [ "$1" == "1" ]; then
        z="32"
    elif [ "$1" == "2" ]; then
        z="34"
    else
        z=""
    fi
    echo -n '\[\033['"$z"'m\]'

}
PS1="`color 1`\u@\h`color`:`color 2`\w`color`\$ "
unset c
unset COLORFGBG


# see also http://mywiki.wooledge.org/BashFAQ/088
HISTSIZE=10000000000000
HISTFILESIZE=10000000000000
HISTIGNORE=""
HISTCONTROL=""
export HISTTIMEFORMAT="%y-%m-%d %T "
function flushhistory() {
    history -a;
}
add_prompt_command flushhistory

function displaygit() {
    pushd ~/dotfiles >&/dev/null ; git status -s | _gitabs; popd >&/dev/null 
}
#add_prompt_command displaygit

# enable programmable completion features
# from ubuntu, may be redundant
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

alias vbox="ssh -i ~/.ssh/vbox_vm jamis@192.168.56.101"
alias mv="mv -i"
alias cp="cp -i"
alias file="file -k"
alias gg="git grep --color=auto"
alias log="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold
blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)-
%an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias activate="source venv/bin/activate"
alias icanhaz="sudo apt-get install"
alias viminstall="vim +BundleInstall +qall"
alias cdcu="cd ~/Dropbox/School/Columbia/"
alias showhidden="defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder"

# grind js files into coffee (given a typical js project layout)
function javascriptToCoffee() {
    function find_js_or_coffee() {
        find . -name "*.$1" -o -path './node_modules' -prune -o -path './*components' -prune -o -path './bower_components' -prune -o -path './client/*components' -prune -type f
    }
    for FILE in $(find_js_or_coffee "js")
    do 
        if [ -e $FILE ] ; then        
            COFFEE=${FILE//.js/.coffee}

            echo "grinding ${FILE} to ${COFFEE}"
            js2coffee "$FILE" > "$COFFEE"
        else     
            echo "File: {$1} does not exist!"
        fi
    done
    for FILE in $(find_js_or_coffee "coffee")
    do 
        ditto .${FILE/./} coffee${FILE/./}
    done
}
alias grindcoffee=javascriptToCoffee

function grep_for_process() { 
    ps -ax | grep -i $1
}
alias psg=grep_for_process

function find_biggest_files() {
    n=$1
    if [ $# -eq 0 ]; then
        n=5
    fi
    find . -type f -exec ls -s {} \; | sort -n -r | head -$n
}
alias findbig=find_biggest_files

alias L='|less'
alias G='|grep'
alias T='|tail'
alias H='|head'
alias W='|wc -l'
alias S='|sort'
alias df='df -H'

# relative path exports (hackery) before absolute paths
export PATH=".cabal-sandbox/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/lib/node_modules:$PATH"
export PATH="$HOME/Library/Haskell/bin:$PATH"

export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2376
export DOCKER_CERT_PATH=/Users/jamis/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

export PYTHONPATH="$PYTHONPATH:/usr/local/lib/python2.7/site-packages"

function path(){
    old=$IFS
    IFS=:
    printf "%s\n" $PATH
    IFS=$old
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
