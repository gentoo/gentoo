# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 optfeature

DESCRIPTION="Python module for calculations with uncertainties"
HOMEPAGE="https://pythonhosted.org/uncertainties/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="dev-python/future[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (	dev-python/numpy[${PYTHON_USEDEP}] )
"

distutils_enable_tests nose

python_compile_all() {
	use doc && "${PYTHON}" setup.py build_sphinx
}

python_install_all() {
	use doc && local HTML_DOCS=( build/sphinx/html/. )
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "numpy support" dev-python/numpy
}
