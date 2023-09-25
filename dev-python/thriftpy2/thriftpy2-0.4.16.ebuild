# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Pure python approach of Apache Thrift"
HOMEPAGE="
	https://github.com/Thriftpy/thriftpy2/
	https://pypi.org/project/thriftpy2/
"
SRC_URI="
	https://github.com/Thriftpy/thriftpy2/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/ply[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
# <cython-3: https://bugs.gentoo.org/898722
BDEPEND="
	<dev-python/cython-3[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/tornado[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		tests/test_tornado.py::TornadoRPCTestCase::test_asynchronous_exception
		tests/test_tornado.py::TornadoRPCTestCase::test_asynchronous_result
	)

	cd tests || die
	epytest
}
