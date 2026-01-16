#!/usr/bin/bash

import os
import sys
import argparse

def get_recent_files(directory, n, include_dotfiles=False):
    directory = os.path.abspath(directory.rstrip("/"))
    entries = []
    for entry in os.listdir(directory):
        fullpath = os.path.join(directory, entry)
        if not os.path.isfile(fullpath):
            continue
        if not include_dotfiles and entry.startswith("."):
            continue
        try:
            mtime = os.path.getmtime(fullpath)
        except OSError:
            continue
        entries.append((mtime, fullpath))

    # Sort descending by mtime and print top n
    for _, path in sorted(entries, key=lambda x: -x[0])[:n]:
        print(path)

def main():
    parser = argparse.ArgumentParser(
        description="List N most recently modified files in a directory"
    )
    parser.add_argument("directory", nargs="?", default=".", help="Target directory")
    parser.add_argument("-n", type=int, default=1, help="Number of recent files to show")
    parser.add_argument("--include-dotfiles", action="store_true", help="Include dotfiles in results")
    args = parser.parse_args()

    get_recent_files(args.directory, args.n, args.include_dotfiles)

if __name__ == "__main__":
   main()
