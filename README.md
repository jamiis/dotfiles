dotfiles
========
Symbolically link to these files.

```
ls -s ~/.bashrc bashrc
```

Or, if you already have a .bashrc file you can maintain both.

```
touch ~/.bashrc.global
ln -s ~/.bashrc.global bashrc
echo "source ~/.bashrc.global" >> ~/.bashrc
```

Credit to @lahwran for the foundation of bashrc vimrc.
