# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYPI_VERIFY_REPO=https://github.com/pgjones/quart-trio
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A Quart extension to provide trio support"
HOMEPAGE="
	https://github.com/pgjones/quart-trio/
	https://pypi.org/project/quart-trio/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/hypercorn-0.12.0[${PYTHON_USEDEP}]
	>=dev-python/quart-0.19[${PYTHON_USEDEP}]
	>=dev-python/trio-0.19.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-trio )
distutils_enable_tests pytest

python_test() {
	epytest -o addopts=
}
