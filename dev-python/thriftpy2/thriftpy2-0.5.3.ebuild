# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Pure python approach of Apache Thrift"
HOMEPAGE="
	https://github.com/Thriftpy/thriftpy2/
	https://pypi.org/project/thriftpy2/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	<dev-python/ply-4[${PYTHON_USEDEP}]
	<dev-python/six-2[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/cython-3.0.10[${PYTHON_USEDEP}]
	test? (
		dev-python/tornado[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{asyncio,reraise} )
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/Thriftpy/thriftpy2/pull/319
	"${FILESDIR}/${P}-tomllib.patch"
)

python_test() {
	cd tests || die
	epytest
}
