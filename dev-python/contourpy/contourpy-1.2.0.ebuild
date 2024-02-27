# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python library for calculating contours in 2D quadrilateral grids"
HOMEPAGE="
	https://pypi.org/project/contourpy/
	https://github.com/contourpy/contourpy/
"
SRC_URI="
	https://github.com/contourpy/contourpy/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pybind11-2.6[${PYTHON_USEDEP}]
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/wurlitzer[${PYTHON_USEDEP}]
	)
"

DISTUTILS_ARGS=(
	-Dwerror=false
)

EPYTEST_XDIST=1
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/contourpy/contourpy/pull/327
	"${FILESDIR}/${P}-unicore.patch"
)

python_test() {
	local EPYTEST_IGNORE=(
		# linters
		tests/test_codebase.py
	)
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
