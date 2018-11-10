#!/bin/sh

DIR="${HOME}/.loki/heroes3"

if [ ! -d "${DIR}" ]; then
    echo "* Creating '${DIR}'"
    mkdir -p ${DIR}
fi

# fixes bug #93604
cd ${DIR}

exec GAMES_PREFIX_OPT/heroes3/heroes3 ${@}
