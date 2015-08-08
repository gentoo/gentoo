#!/bin/bash

if [[ $# -gt 1 || $1 == -* ]] ; then
	echo "Usage: $0 [ver]"
	exit 1
fi

set -ex

SPDY_URL_BASE="http://mod-spdy.googlecode.com/svn/tags"

if [[ $# -eq 1 ]] ; then
	PV=$1
else
	svnout=$(svn ls ${SPDY_URL_BASE} | grep -v current | sort -V | tail -1)
	PV=${svnout%/}
fi

PN="mod_spdy"
P="${PN}-${PV}"

: ${TMPDIR:=/tmp}

tmp="${TMPDIR}/${PN}"
rm -rf "${tmp}"
mkdir "${tmp}"
cd "${tmp}"

DEPOT_TOOLS_URL="https://chromium.googlesource.com/chromium/tools/depot_tools.git"
SPDY_URL="http://mod-spdy.googlecode.com/svn/tags/${PV}/src"

git clone --single-branch --depth 1 ${DEPOT_TOOLS_URL}
rm -rf depot_tools/.git
PATH=${PWD}/depot_tools:${PATH}
mkdir ${P}
cd ${P}
gclient config ${SPDY_URL}
gclient sync --force --nohooks --delete_unversioned_trees
cd ..

tar cf - depot_tools ${P} | xz > ${P}.tar.xz

mv ${P}.tar.xz "${TMPDIR}"/
cd /
rm -rf "${tmp}"

du -hb "${TMPDIR}/${P}.tar.xz"
