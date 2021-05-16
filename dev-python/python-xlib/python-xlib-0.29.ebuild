# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 virtualx

DESCRIPTION="A fully functional X client library for Python, written in Python"
HOMEPAGE="https://github.com/python-xlib/python-xlib"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86"
IUSE="doc"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	doc? ( sys-apps/texinfo )
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

distutils_enable_tests unittest

python_compile_all() {
	use doc && emake -C doc/info
}

src_test() {
	virtx distutils-r1_src_test
}

python_install_all() {
	use doc && doinfo doc/info/*.info
	distutils-r1_python_install_all
}
