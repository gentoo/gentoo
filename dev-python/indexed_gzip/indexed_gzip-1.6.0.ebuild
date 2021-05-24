# Copyright 1999-2021 Gentoo Authors
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

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov=indexed_gzip::' setup.cfg || die
	distutils-r1_src_prepare
}

src_compile() {
	if use test; then
		export INDEXED_GZIP_TESTING=1
	fi
	distutils-r1_src_compile
}

python_test() {
	local ignore=(
		# requires nibabel
		indexed_gzip/tests/test_nibabel_integration.py
	)

	cd "${BUILD_DIR}"/lib || die
	epytest ${ignore[@]/#/--ignore }
}
