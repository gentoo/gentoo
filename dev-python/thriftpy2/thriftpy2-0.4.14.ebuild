# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="Pure python approach of Apache Thrift"
HOMEPAGE="https://github.com/Thriftpy/thriftpy2"
SRC_URI="https://github.com/Thriftpy/thriftpy2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/ply[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		www-servers/tornado[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests --install pytest

python_prepare_all() {
	rm tests/test_tornado.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing --via-root
	pushd tests >/dev/null || die
	epytest
	popd >/dev/null || die
}
