# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A virtual for PyPy3 Python implementation"
# XX from pypy3-XX.so module suffix
SLOT="0/58"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="bzip2 gdbm ncurses sqlite tk"

RDEPEND="
	|| (
		>=dev-python/pypy3-${PV}:${SLOT}[bzip2?,gdbm(-)?,ncurses?,sqlite?,tk?]
		>=dev-python/pypy3-bin-${PV}:${SLOT}[gdbm(-)?,sqlite?,tk?]
	)"
