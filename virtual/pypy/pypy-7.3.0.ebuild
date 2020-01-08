# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An obsolete virtual for PyPy Python implementation"
# pypy -c 'import sysconfig; print sysconfig.get_config_var("SOABI")'
SLOT="0/73"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 gdbm ncurses sqlite tk"

RDEPEND="
	>=dev-python/pypy-${PV}:${SLOT}[bzip2?,gdbm(-)?,ncurses?,sqlite?,tk?]"
