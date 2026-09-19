# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="A pure Python module for creation and analysis of binary data"
HOMEPAGE="
	https://github.com/scott-griffiths/bitstring/
	https://pypi.org/project/bitstring/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	=dev-python/bitarray-3*[${PYTHON_USEDEP}]
	>=dev-python/gfloat-0.1[${PYTHON_USEDEP}]
	>=dev-python/tibs-0.5.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( hypothesis )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# https://github.com/scott-griffiths/bitstring/issues/363
	tests/test_fp8.py::TestConversionToFP8::test_compare_8bit_floats_with_gfloat
	tests/test_fp8.py::test_rounding_consistent_to_gfloat
)

EPYTEST_IGNORE=(
	tests/test_benchmarks.py
)

src_prepare() {
	distutils-r1_src_prepare

	# unpin dependencies
	sed -i -e 's:, < [0-9.]*::' pyproject.toml || die
}
