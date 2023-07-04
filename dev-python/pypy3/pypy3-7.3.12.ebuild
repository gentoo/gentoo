# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYVER=3.10
DESCRIPTION="A fast, compliant alternative implementation of the Python (${PYVER}) language"
HOMEPAGE="
	https://www.pypy.org/
	https://foss.heptapod.net/pypy/pypy/
"
S=${WORKDIR}

LICENSE="MIT"
SLOT="0/pypy310-pp73-384"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+gdbm ncurses sqlite tk"

RDEPEND="
	=dev-python/pypy3_10-${PV}*:${SLOT}[gdbm?,ncurses?,sqlite?,tk?]
"

src_install() {
	dodir /usr/bin
	dosym pypy${PYVER} /usr/bin/pypy3
}
