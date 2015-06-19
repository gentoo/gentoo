#!/bin/sh
VERSION=$(date +%Y%m%d)
PACKAGE="collada-dom-2.4.3_pre${VERSION}"

git clone https://github.com/rdiankov/collada-dom ${PACKAGE}

find "${PACKAGE}" -type d -name '.git' -prune -print0 | xargs -0 rm -rf

tar cJf ${PACKAGE}.tar.xz ${PACKAGE}
rm -rf ${PACKAGE}/

echo "Tarball: \"${PACKAGE}.tar.xz\""

echo "** all done **"
