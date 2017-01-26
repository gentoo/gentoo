# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator

DESCRIPTION="A virtual for PyPy3 Python implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
# XX from pypy3-XX.so module suffix
SLOT="0/55"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 gdbm ncurses sqlite tk"

RDEPEND="
	|| (
		>=dev-python/pypy3-${PV}:${SLOT}[bzip2?,gdbm(-)?,ncurses?,sqlite?,tk?]
		>=dev-python/pypy3-bin-${PV}:${SLOT}[gdbm(-)?,sqlite?,tk?]
	)"
