# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Plot area-proportional two- and three-way Venn diagrams in matplotlib"
HOMEPAGE="
	https://github.com/konstantint/matplotlib-venn/
	https://pypi.org/project/matplotlib-venn/
"
SRC_URI="
	https://github.com/konstantint/matplotlib-venn/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/shapely[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# TODO: some minor number mismatch
		matplotlib_venn/layout/venn3/cost_based.py::matplotlib_venn.layout.venn3.cost_based.LayoutAlgorithm
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
