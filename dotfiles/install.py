#!/usr/bin/env python

import subprocess
import sys
import logging
import datetime
import os
import stat
import time

from dotfiles import wrap_process
from dotfiles.highlight import highlight
from dotfiles import wrap_process
from dotfiles import os_specific

assert (0644 ==
        stat.S_IRUSR |
        stat.S_IWUSR |
        stat.S_IRGRP |
        stat.S_IROTH), "os is insane"

logger = logging.getLogger("-")

os_dependencies = [
    "vim",
    "git",
    "pip",
    "fail2ban",
    "build-essential",
    "python-dev",
    "ntp-daemon",
    "tmux",
    "tig"
]

pip_dependencies = [
    "virtualenv",
    "pytest",
    "twisted",
    "blessings",
    "watchdog",
]

ensure_nonexistant = [
    "~/.bash_logout",
]

def fullpath(*args):
    _p = os.path
    return _p.abspath(_p.normpath(_p.expanduser(_p.join(*args))))
    del _p

projectroot = fullpath(os.path.dirname(__file__), "..")

def path(*args):
    return fullpath(projectroot, *args)

def install_text(filename, text, permissions=None,
        before=False, prev_existance=True):
    filename = fullpath(filename)
    try:
        with open(filename, "r") as reader:
            contents = reader.read()
    except IOError as e:
        if e.errno == 2 and not prev_existance:
            contents = ""
        else:
            raise

    if text not in contents:
        if before:
            contents = text + "\n" + contents
        else:
            contents += "\n" + text
        with open(filename, "w") as writer:
            # rewrite whole thing to prevent race conditions
            writer.write(contents)

    if permissions is not None:
        os.chmod(filename, permissions)


def install_dir(target, log=True):
    target = fullpath(target)
    try:
        os.makedirs(target)
    except OSError as e:
        if e.errno == 17:
            pass
        else:
            raise


def install_file(master, target):
    # link master to target
    logger.info("installing %s -> %s", master, target)
    master = path(master)
    target = fullpath(target)

    install_dir(os.path.dirname(target), log=False)

    try:
        os.symlink(master, target)
    except OSError as e:
        if e.errno == 17:
            assert fullpath(os.readlink(target)) == master, (
                    "%s is installed to %s incorrectly: %s" % (master, target, fullpath(os.readlink(target))))
        else:
            raise

def delete_text(filename, *text):
    logger.info("deleting text from %s", filename)
    filename = fullpath(filename)
    text = "\n%s\n" % ("\n".join(text).strip("\n"))

    with open(filename, "r") as reader:
        contents = reader.read()

    if text in contents:
        contents = contents.replace(text, "\n")

        with open(filename, "w") as writer:
            # rewrite whole thing to prevent race conditions
            writer.write(contents)
    

def readfile(filename):
    with open(path(filename), "r") as reader:
        result = reader.read().strip()
    return result


def user_install():
    global logger

    # install pip packages
    logger.info("Installing pip packages...")
    for dep in pip_dependencies:
        wrap_process.call("pip", ["pip", "install", "--user", "-M", dep])

    logger = logging.getLogger("u")
    logger.info("Doing user install...")

    for filename in ensure_nonexistant:
        filename = fullpath(filename)
        basename = os.path.basename(filename)
        dirname = os.path.dirname(filename)
        target = os.path.join(dirname, ".__dotfiles_deleted_%s_%s_" % (basename, int(time.time())))
        logger.info("moving %s to %s", filename, target)
        try:
            os.rename(filename, target)
        except OSError as e:
            if e.errno == 2:
                pass
            else:
                raise

    install_text("~/.vimrc", "source ~/.vimrc_global",
            before=True, prev_existance=False)
    install_text("~/.vimrc", "set nocompatible", 0600,
            before=True)
    install_file("files/vimrc", "~/.vimrc_global")
    install_file("files/vimrc_newsession", "~/.vimrc_newsession")

    install_text("~/.bashrc", "source ~/.bashrc_global")
    install_file("files/bashrc", "~/.bashrc_global")
    delete_text("~/.bashrc",
        "# enable programmable completion features (you don't need to enable",
        "# this, if it's already enabled in /etc/bash.bashrc and /etc/profile",
        "# sources /etc/bash.bashrc).",
        "if [ -f /etc/bash_completion ] && ! shopt -oq posix; then",
        "    . /etc/bash_completion",
        "fi"
    )

    install_text("~/.profile", readfile("files/profile_include"))
    install_text("~/.profile", "source ~/.profile_global")
    install_file("files/profile", "~/.profile_global")

    wrap_process.call("git submodule", ["git", "submodule", "init"], wd=projectroot)
    wrap_process.call("git submodule", ["git", "submodule", "update"], wd=projectroot)

    install_file("submodules/pathogen/autoload/pathogen.vim", "~/.vim/autoload/pathogen.vim")
    install_file("submodules/nerdtree/", "~/.vim/bundle/nerdtree/")
    install_file("submodules/ctrlp/", "~/.vim/bundle/ctrlp/")
    install_file("submodules/fugitive/", "~/.vim/bundle/fugitive/")


def root_install():
    global logger
    logger = logging.getLogger("s")

    # install os packages
    logger.info("Installing OS packages...")
    os_specific.install_packages(os_dependencies)

    # install global environment defaults
    logger.info("Installing environment defaults...")
    install_text("/etc/environment", readfile("files/global_environ"))

    

def init_logging(mode):
    rootlogger = logging.getLogger()
    prefix = "\033[32m"
    formatter = logging.Formatter('[%(relativeCreated)6dms ' + highlight(mode) + ' %(levelname)s] ' +
                                        highlight('%(name)s') + ': %(message)s')
    rootlogger.setLevel(logging.DEBUG)
    today = datetime.date.today()
    today_str = today.strftime("%Y-%m-%d")
    logfile = open(".install_%s.log" % today_str, "a")
    handlers = [
        logging.StreamHandler(sys.stdout),
        logging.StreamHandler(logfile)
    ]
    for handler in handlers:
        handler.setFormatter(formatter)
        rootlogger.addHandler(handler)
    logger.info("Logging initialized")

def main(mode="init", *args):
    init_logging(mode)

    if mode == "superuser":
        root_install(*args)
    elif mode == "init":
        logger.info("running root portion")
        subprocess.call(["sudo", sys.executable, sys.argv[0], "superuser"] + list(args))
        logger.info("running user portion")
        user_install(*args)
    elif mode == "user":
        user_install(*args)
    else:
        logger.error("mode must be one of 'superuser', 'init', 'user': %s", mode)

if __name__ == "__main__":
    main(*sys.argv[1:])
