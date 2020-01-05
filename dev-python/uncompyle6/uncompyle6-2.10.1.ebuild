# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Python cross-version byte-code deparser"
HOMEPAGE="https://github.com/rocky/python-uncompyle6/ https://pypi.org/project/uncompyle6/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/xdis-3.3.1
	<dev-python/xdis-3.4.0
	>=dev-python/spark-parser-1.6.1
	<dev-python/spark-parser-1.7.0"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/nose-1.0[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	distutils-r1_python_prepare_all
}

# only run the recommended "make check" tests
python_test() {
	distutils_install_for_testing

	PYTHONPATH="${S}/test:${BUILD_DIR}/lib" \
		emake check
}
