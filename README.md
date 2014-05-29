dotfiles
========
Symbolically link to these files.

```
ls -s ~/.bashrc bashrc
```

Or, if you already have a .bashrc file you can maintain both.

```
ln -s ~/dotfiles/bashrc ~/.bashrc.global
echo "source ~/.bashrc.global" >> ~/.bashrc
```

Credit to @lahwran for the foundation of bashrc vimrc.
