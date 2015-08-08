#!/bin/sh
VERSION=$(date +%Y%m%d)
BASE_VERSION="0.0"
PACKAGE="libcxx-${BASE_VERSION}_p${VERSION}"

svn co http://llvm.org/svn/llvm-project/libcxx/trunk ${PACKAGE}

find "${PACKAGE}" -type d -name '.svn' -prune -print0 | xargs -0 rm -rf
find "${PACKAGE}" -type d -name '.git' -prune -print0 | xargs -0 rm -rf

tar cJf ${PACKAGE}.tar.xz ${PACKAGE}
rm -rf ${PACKAGE}/

echo "Tarball: \"${PACKAGE}.tar.xz\""

echo "** all done **"
