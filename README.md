dotfiles
========
NOTE: submodules exist so clone with `--recursive`

### Setup

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

### Install Vim package manager Vundle

`git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

Open vim and run `:PluginInstall` to install all vim packages.
NOTE: colorscheme error won't appear anymore after running `PluginInstall`
