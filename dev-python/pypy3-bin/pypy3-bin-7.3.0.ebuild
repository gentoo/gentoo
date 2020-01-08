# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Backwards compatibility package to install binary ver of PyPy3"
HOMEPAGE="https://pypy.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0/pypy36-pp73"
KEYWORDS="~amd64 ~x86"
IUSE="gdbm libressl sqlite tk"

RDEPEND="
	dev-python/pypy3-exe-bin:${PV}
	~dev-python/pypy3-${PV}[gdbm?,libressl?,sqlite?,tk?]"
