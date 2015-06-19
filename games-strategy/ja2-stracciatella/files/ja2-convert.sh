#!/bin/sh
# Convert names of data-files to lower-case

# location of the data-files
GAMES_DATADIR=@GAMES_DATADIR@

cd "${GAMES_DATADIR}" || exit 1

# convert to lowercase
find . -exec sh -c 'echo "${1}"
lower="`echo "${1}" | tr [:upper:] [:lower:]`"
[ -d `dirname "${lower}"` ] || mkdir `dirname ${lower}`
[ "${1}" = "${lower}" ] || mv "${1}" "${lower}"' - {} \;

# remove leftover
rm -r ./TILECACHE ./STSOUNDS
