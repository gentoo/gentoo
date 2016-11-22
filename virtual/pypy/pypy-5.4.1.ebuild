# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator

DESCRIPTION="A virtual for PyPy Python implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
# pypy -c 'import sysconfig; print sysconfig.get_config_var("SOABI")'
SLOT="0/41"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 gdbm ncurses sqlite tk"

RDEPEND="
	|| (
		>=dev-python/pypy-${PV}:${SLOT}[bzip2?,gdbm(-)?,ncurses?,sqlite?,tk?]
		>=dev-python/pypy-bin-${PV}:${SLOT}[gdbm(-)?,sqlite?,tk?]
	)"
