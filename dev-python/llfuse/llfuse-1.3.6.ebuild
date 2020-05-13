# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Python bindings for the low-level FUSE API"
HOMEPAGE="https://github.com/python-llfuse/python-llfuse/ https://pypi.org/project/llfuse/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="
	>=sys-fs/fuse-2.8.0:0
"
DEPEND="
	sys-apps/attr
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/llfuse-1.3.5-cflags.patch
)

distutils_enable_tests pytest

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
