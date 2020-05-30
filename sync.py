#!/usr/bin/env python

"""
Dotfiles syncronization.
Makes symlinks for all files:
  ./home/.zshrc will be available as ~/.zshrc.
  ./home/.ssh__config will be available as ~/.ssh/config
Based on: https://github.com/denysdovhan/dotfiles/blob/master/sync.py
"""

import os
import sys
import glob
import shutil

from builtins import input

# Get first, second an third arguments
arg1 = sys.argv[1] if 1 < len(sys.argv) else None  # Source
arg2 = sys.argv[2] if 2 < len(sys.argv) else None  # Dest
arg3 = sys.argv[3] if 3 < len(sys.argv) else None  # Backup

DOTFILES_DIR = os.path.dirname(os.path.abspath(__file__))
SOURCE_DIR = os.path.join(DOTFILES_DIR, arg1 or "home")
DEST_DIR = arg2 or os.path.expanduser("~")
BACKUP_DIR = os.path.join(DOTFILES_DIR, arg3 or "backup")
EXCLUDE = []


def forse_remove(path):
    """Remove path."""
    if os.path.isdir(path) and not os.path.islink(path):
        shutil.rmtree(path, False)
    else:
        os.unlink(path)


def is_link_to(link, dest):
    """Ckeck if is this a link to dest."""
    is_link = os.path.islink(link)
    is_link = is_link and os.readlink(link).rstrip("/") == dest.rstrip("/")
    return is_link


def copy(path, dest):
    """Copy path to dest."""
    if os.path.isdir(path):
        shutil.copytree(path, dest)
    else:
        shutil.copy(path, dest)


def main():
    os.chdir(SOURCE_DIR)
    for filename in [file for file in os.listdir(".") if file not in EXCLUDE]:
        dotfile = os.path.join(DEST_DIR, *filename.split("__"))
        source = os.path.relpath(filename, os.path.dirname(dotfile))

        # check that we aren't overwriting anything
        if os.path.exists(dotfile):
            if is_link_to(dotfile, source):
                continue

            res = input("Overwrite file `%s'? [y/N] " % dotfile)
            if not res.lower().startswith("y"):
                print("Skipping '{0}'...".format(dotfile))
                continue
            else:
                # Made backup copy if we're overwriting this file
                res = input("Make a backup of '%s'? [y/N] " % dotfile)
                if res.lower().startswith("y"):
                    if not os.path.exists(BACKUP_DIR):
                        os.mkdir(BACKUP_DIR)
                    backup = os.path.join(BACKUP_DIR, os.path.basename(dotfile))
                    copy(dotfile, backup)
                    print("Made a backup '{0}'".format(backup))

            forse_remove(dotfile)

        dotfile_dir = os.path.dirname(dotfile)
        if not os.path.exists(dotfile_dir):
            os.makedirs(dotfile_dir)

        os.symlink(source, dotfile)
        print("{0} => {1}".format(dotfile, source))


if __name__ == "__main__":
    main()
