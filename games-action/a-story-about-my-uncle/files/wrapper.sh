#!/bin/sh -eu

# Unfortunately, this game always writes within its own installation directory
# rather than HOME. We work around this with bubblewrap.

DIR="${HOME}"/.local/share/ASAMU
mkdir -p "${DIR}"/Saves
cp -r --preserve=timestamps /opt/ASAMU/ASAMU/Config/ "${DIR}"/
exec bwrap --bind / / --dev-bind /dev /dev --bind "${DIR}"/Config /opt/ASAMU/ASAMU/Config --bind "${DIR}"/Saves /opt/ASAMU/ASAMU/Saves /opt/ASAMU/Binaries/gentoo/ASAMU "${@}"
