# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Backwards compatibility package to install binary ver of PyPy"
HOMEPAGE="https://pypy.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0/73"
KEYWORDS="~amd64 ~x86"
IUSE="gdbm libressl sqlite tk"

RDEPEND="
	dev-python/pypy-exe-bin:${PV}
	~dev-python/pypy-${PV}[gdbm?,libressl?,sqlite?,tk?]"
