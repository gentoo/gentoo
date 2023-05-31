# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYVER=3.9
DESCRIPTION="A fast, compliant alternative implementation of the Python (${PYVER}) language"
HOMEPAGE="
	https://www.pypy.org/
	https://foss.heptapod.net/pypy/pypy/
"
S=${WORKDIR}

LICENSE="MIT"
SLOT="0/pypy39-pp73-336"
KEYWORDS=""
IUSE="+gdbm ncurses sqlite tk"

RDEPEND="
	=dev-python/pypy3_9-${PV}*:${SLOT}[gdbm?,ncurses?,sqlite?,tk?]
"

src_install() {
	dodir /usr/bin
	dosym pypy${PYVER} /usr/bin/pypy3
}
