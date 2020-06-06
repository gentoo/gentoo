# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1

DESCRIPTION="High performance compressor optimized for binary data"
HOMEPAGE="http://python-blosc.blosc.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/c-blosc:="
DEPEND="${RDEPEND}
	dev-python/scikit-build[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	export BLOSC_DIR="${EPREFIX}/usr"
	distutils-r1_python_prepare_all
	DOCS=( ANNOUNCE.rst  README.rst  RELEASE_NOTES.rst )
}

python_compile_all() {
	esetup.py build_clib
	esetup.py build_ext --inplace
	esetup.py build
}

python_test() {
	cd "${BUILD_DIR}"/lib || die
	PYTHONPATH=. nosetests -v || die
}

python_install() {
	distutils-r1_python_install
	python_optimize
}
