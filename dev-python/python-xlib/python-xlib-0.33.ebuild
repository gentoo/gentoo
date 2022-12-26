# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 virtualx

DESCRIPTION="A fully functional X client library for Python, written in Python"
HOMEPAGE="
	https://github.com/python-xlib/python-xlib/
	https://pypi.org/project/python-xlib/
"
SRC_URI="
	https://github.com/python-xlib/python-xlib/releases/download/${PV}/${P}.tar.bz2
"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
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
