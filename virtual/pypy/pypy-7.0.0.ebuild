# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A virtual for PyPy Python implementation"
# pypy -c 'import sysconfig; print sysconfig.get_config_var("SOABI")'
# pypy 7.0.0: install directory changed to 'pypy2.7'
SLOT="0/41-py27"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 gdbm ncurses sqlite tk"

RDEPEND="
	|| (
		>=dev-python/pypy-${PV}:${SLOT}[bzip2?,gdbm(-)?,ncurses?,sqlite?,tk?]
		>=dev-python/pypy-bin-${PV}:${SLOT}[gdbm(-)?,sqlite?,tk?]
	)"
