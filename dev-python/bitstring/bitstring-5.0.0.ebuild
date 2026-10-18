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
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/gfloat-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/tibs-2.0.2[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( hypothesis )
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	tests/test_benchmarks.py
)

src_prepare() {
	distutils-r1_src_prepare

	# unpin dependencies
	sed -i -e 's:, < [0-9.]*::' pyproject.toml || die
}
