# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1 virtualx

DESCRIPTION="A fully functional X client library for Python, written in Python"
HOMEPAGE="https://github.com/python-xlib/python-xlib"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	doc? ( sys-apps/texinfo )"

# DISTUTILS_IN_SOURCE_BUILD=1

python_compile_all() {
	use doc && emake -C doc/info
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && doinfo doc/info/*.info
	distutils-r1_python_install_all
}
