# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A virtual for PyPy3 Python implementation"
# pypy3 -c 'import sysconfig; print(sysconfig.get_config_var("SOABI"))'
SLOT="0/pypy36-pp73"
KEYWORDS=""
IUSE="bzip2 gdbm ncurses sqlite tk"

RDEPEND="
	|| (
		>=dev-python/pypy3-${PV}:${SLOT}[bzip2?,gdbm(-)?,ncurses?,sqlite?,tk?]
		>=dev-python/pypy3-bin-${PV}:${SLOT}[gdbm(-)?,sqlite?,tk?]
	)"
