# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python module to describe statistical models and design matrices"
HOMEPAGE="https://patsy.readthedocs.org/en/latest/index.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	"
BDEPEND="
	doc? (
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		)"

distutils_enable_tests nose

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use doc && HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
