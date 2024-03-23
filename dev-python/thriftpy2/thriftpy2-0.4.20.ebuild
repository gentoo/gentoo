# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Pure python approach of Apache Thrift"
HOMEPAGE="
	https://github.com/Thriftpy/thriftpy2/
	https://pypi.org/project/thriftpy2/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/ply[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/tornado[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_compile() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/857105
	# https://github.com/Thriftpy/thriftpy2/issues/246
	#
	# Don't trust this to LTO
	append-flags -fno-strict-aliasing
	filter-lto

	distutils-r1_src_compile
}

python_test() {
	local EPYTEST_DESELECT=(
		tests/test_tornado.py::TornadoRPCTestCase::test_asynchronous_exception
		tests/test_tornado.py::TornadoRPCTestCase::test_asynchronous_result
	)

	cd tests || die
	epytest
}
