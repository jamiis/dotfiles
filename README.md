dotfiles
========
Symbolically link to these files.

```
ls -s path/to/dotfiles/bashrc ~/.bashrc
```

Or, if you already have a .bashrc file you can maintain both.

```
cd ~
ln -s path/to/dotfiles/bashrc .bashrc.global
echo "source .bashrc.global" >> .bashrc
```

NOTE: submodules exist so clone with `--recursive`
