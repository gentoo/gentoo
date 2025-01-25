# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A Quart extension to provide trio support"
HOMEPAGE="
	https://github.com/pgjones/quart-trio/
	https://pypi.org/project/quart-trio/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/exceptiongroup-1.1.0[${PYTHON_USEDEP}]
	' 3.10)
	>=dev-python/hypercorn-0.12.0[${PYTHON_USEDEP}]
	>=dev-python/quart-0.19[${PYTHON_USEDEP}]
	>=dev-python/trio-0.19.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-trio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts= -p trio
}
