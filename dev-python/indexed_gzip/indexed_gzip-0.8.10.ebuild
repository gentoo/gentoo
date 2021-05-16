# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 virtualx

DESCRIPTION="Fast random access of gzip files in Python"
HOMEPAGE="https://github.com/pauldmccarthy/indexed_gzip"
SRC_URI="https://github.com/pauldmccarthy/indexed_gzip/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	"
RDEPEND=""

distutils_enable_tests pytest

src_compile() {
	if use test; then
		export INDEXED_GZIP_TESTING=1
	fi
	distutils-r1_src_compile
}

python_test() {
	cp conftest.py "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die
	pytest -vv --nelems 500000 --niters 250 || die
}
