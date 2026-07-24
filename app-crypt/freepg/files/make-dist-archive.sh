#!/bin/sh

if [ ${#} -ne 1 ]; then
	echo "Usage: ${0} <version>"
	exit 1
fi

set -e -x

PV=${1}
TAG=gnupg-${PV}-freepg

git clone --depth 1 --branch "${TAG}" https://gitlab.com/freepg/gnupg
cd gnupg
rm -r -f .git
sed -i -e '/beta=yes/d' -e 's:-unknown:-freepg:' autogen.sh
# bashisms
bash autogen.sh
./configure --enable-maintainer-mode
# parallel can fail
make dist
gpg --detach-sign "${TAG}".tar.bz2
kup putraw "${TAG}".tar.bz2 "${TAG}".tar.bz2.sig /pub/dev/mgorny@gentoo.org/freepg/
cd ..
rm -r -f gnupg
