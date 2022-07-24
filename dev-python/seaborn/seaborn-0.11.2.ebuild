# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Statistical data visualization"
HOMEPAGE="https://seaborn.pydata.org https://github.com/mwaskom/seaborn"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/statsmodels[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
BDEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${PN}-Update-tests-for-compatability-with-matplotlib-3.5.0.patch
)

distutils_enable_tests pytest

python_test() {
	# Tests fail due to a newer matplotlib (3.5) being used. Was fixed
	# upstream in https://github.com/mwaskom/seaborn/issues/2663 but not
	# for the 0.11 branch. Partially backported in
	# seaborn-Update-tests-for-compatability-with-matplotlib-3.5.0.patch.
	local EPYTEST_DESELECT=(
		'seaborn/tests/test_categorical.py::TestBoxPlotter::test_axes_data'
		'seaborn/tests/test_categorical.py::TestBoxPlotter::test_box_colors'
		'seaborn/tests/test_categorical.py::TestBoxPlotter::test_draw_missing_boxes'
		'seaborn/tests/test_categorical.py::TestBoxPlotter::test_missing_data'
		'seaborn/tests/test_categorical.py::TestCatPlot::test_plot_elements'
		'seaborn/tests/test_categorical.py::TestBoxenPlotter::test_box_colors'
		'seaborn/tests/test_distributions.py::TestKDEPlotUnivariate::test_legend'
		'seaborn/tests/test_distributions.py::TestKDEPlotBivariate::test_fill_artists'
		'seaborn/tests/test_distributions.py::TestDisPlot::test_with_rug[kwargs0]'
		'seaborn/tests/test_distributions.py::TestDisPlot::test_with_rug[kwargs1]'
		'seaborn/tests/test_distributions.py::TestDisPlot::test_with_rug[kwargs2]'
	)
	cat > matplotlibrc <<- EOF || die
		backend : Agg
	EOF
	epytest
}
