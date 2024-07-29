# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Universal Binary JSON encoder/decoder"
HOMEPAGE="
	https://github.com/Iotic-Labs/py-ubjson/
	https://pypi.org/project/py-ubjson/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/Iotic-Labs/py-ubjson/pull/19
	"${FILESDIR}/${P}-py312.patch"
)

python_test() {
	local EPYTEST_DESELECT=(
		# the usual problem with random packages increasing recursion limit
		test/test.py::TestEncodeDecodePlainExt::test_recursion
		test/test.py::TestEncodeDecodeFpExt::test_recursion
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest test/test.py
}
