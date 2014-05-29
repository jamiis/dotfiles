dotfiles
========
Symbolically link to these files.

```
ls -s ~/.bashrc bashrc
```

Or, if you already have a .bashrc file you can maintain both.

```
cd ~
ln -s path/to/dotfiles/bashrc .bashrc.global
echo "source .bashrc.global" >> .bashrc
```

Credit to @lahwran for the foundation of bashrc vimrc.
