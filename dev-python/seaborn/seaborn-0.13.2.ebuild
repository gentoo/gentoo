# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Statistical data visualization"
HOMEPAGE="
	https://seaborn.pydata.org/
	https://github.com/mwaskom/seaborn/
	https://pypi.org/project/seaborn/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~amd64-linux"

RDEPEND="
	>=dev-python/matplotlib-3.4[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
	>=dev-python/pandas-1.2[${PYTHON_USEDEP}]
	>=dev-python/statsmodels-0.12[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.7[${PYTHON_USEDEP}]
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_test() {
	cat > matplotlibrc <<- EOF || die
		backend : Agg
	EOF

	distutils-r1_src_test
}
