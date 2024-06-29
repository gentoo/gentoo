# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A pure Python module for creation and analysis of binary data"
HOMEPAGE="
	https://github.com/scott-griffiths/bitstring/
	https://pypi.org/project/bitstring/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

RDEPEND="
	<dev-python/bitarray-3[${PYTHON_USEDEP}]
	>=dev-python/bitarray-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/gfloat-0.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	tests/test_benchmarks.py
)
