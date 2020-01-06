# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Provides columnar and compressed data containers"
HOMEPAGE="http://bcolz.blosc.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/c-blosc:=
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
	)
	test? (	dev-python/mock[${PYTHON_USEDEP}] )
"

python_compile() {
	distutils-r1_python_compile --blosc="${EPREFIX}/usr"
}

python_compile_all() {
	use doc && sphinx-build -b html -N docs/ docs/_build/html
}

python_test() {
	cd "${BUILD_DIR}"/lib
	"${PYTHON}" -c 'import bcolz; bcolz.test()' || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
	dodoc *.rst
}
