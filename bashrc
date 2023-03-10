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
#case "$TERM" in (xterm*|rxvt*)
    #PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u on \h: \w\a\] λ"
    #;;
#*)
    #;;
#esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u on \h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\λ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u on \h:\w\λ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u on \h: \w\a\]λ"
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

# currently xmodmap swaps caps-lock and esc
if [ "$(uname)" == 'Linux' ]; then
    xmodmap ~/.xmodmaprc
fi

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
PS1="`color 1`\u on \h`color` `color 2`\w`color` → "
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

# enable programmable completion features
# from ubuntu, may be redundant
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

alias mv="mv -i"
alias cp="cp -i"
alias file="file -k"
alias gg="git grep --color=auto"
alias log="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold
blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)-
%an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias activate="source venv/bin/activate"
alias icanhaz="sudo apt-get install"
alias installvundleplugins="vim +BundleInstall +qall"
alias installvundle="git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim"
alias showhidden="defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder"
alias brewery="brew update && brew upgrade && brew cleanup"

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
export PATH="/usr/local/bin:$PATH"
# export PATH="/usr/local/lib/node_modules:$PATH"

# docker
alias b2dinit=$(boot2docker shellinit 2> /dev/null)
alias b2dip='boot2docker ip 2> /dev/null'
alias dps='docker ps'
alias dpsl='docker ps -l'
alias dpsa='docker ps -l'
alias dsh='docker exec -it `docker ps -lq` bash'
alias dip='docker inspect $(docker ps -lq) | grep IPAddress'

function path(){
    echo $PATH | sed 's/:/\n/g' | sort | uniq -c
}

# nvm PATH
export NVM_DIR="/Users/jamis/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# python PATH for homebrew
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
