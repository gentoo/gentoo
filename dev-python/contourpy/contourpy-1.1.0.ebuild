# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{10..11} )

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
KEYWORDS="~amd64 ~hppa ~ia64 ~riscv ~x86"

RDEPEND="
	>=dev-python/numpy-1.16[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pybind11-2.6[${PYTHON_USEDEP}]
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/wurlitzer[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# linters
		tests/test_codebase.py
	)
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
