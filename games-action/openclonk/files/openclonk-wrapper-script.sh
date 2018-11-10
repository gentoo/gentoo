#!/bin/sh
# wrapper prevents the game to look for .ocp files in the current dir
# which can lead to weird behavior and game freeze

[ -d ~/.clonk/openclonk ] || mkdir -p ~/.clonk/openclonk

cd ~/.clonk/openclonk

exec clonk "$@"
