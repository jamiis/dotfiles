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

umask 077

export PATH=/Users/jamis/torch/install/bin:$PATH  # Added automatically by torch-dist
export LD_LIBRARY_PATH=/Users/jamis/torch/install/lib:$LD_LIBRARY_PATH  # Added automatically by torch-dist
export DYLD_LIBRARY_PATH=/Users/jamis/torch/install/lib:$DYLD_LIBRARY_PATH  # Added automatically by torch-dist
