# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

source ~/.profile.global

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
