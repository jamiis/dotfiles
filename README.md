dotfiles
========
NOTE: submodules exist so clone with `--recursive`

## Setup

Symbolically link to these files so they update with `git pull`s

```
ln -s path/to/dotfiles/bashrc ~/.bashrc
```

Or, if you already have a .bashrc file you can maintain both.

```
cd ~
ln -s path/to/dotfiles/bashrc .bashrc.global
echo "source .bashrc.global" >> .bashrc
```

You should do your choice of the above for `.vimrc`, `.bashrc`, `.tmux.conf`, 
`tmux.conf.local`, and `.gitconfig`, all in your home directory `~`.

tmux config files exist in `.tmux/` submodule so make sure to clone with `--recursive`.

## Install vim package manager [Vundle](https://github.com/VundleVim/Vundle.vim)

`git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

Open vim and run `:PluginInstall` to install all vim packages.
NOTE: colorscheme error won't appear anymore after running `PluginInstall`

## Install tmux package manager [TPM](https://github.com/tmux-plugins/tpm)

`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

Ensure it is sourced 

`tmux source-file ~/.tmux.conf`

## Extras

#### Homebrew

Install important packages and desktop applications. Make sure [Homebrew](https://brew.sh/) is installed first.

`sh ./scripts/brew.sh`

#### Vim bindings for iPython

`ipython profile create`

edit `~/.ipython/profile_default/ipython_config.py` so `c.TerminalInteractiveShell.editing_mode = 'vi'`
