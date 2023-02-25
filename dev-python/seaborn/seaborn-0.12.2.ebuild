# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 multiprocessing pypi

DESCRIPTION="Statistical data visualization"
HOMEPAGE="https://seaborn.pydata.org https://github.com/mwaskom/seaborn"

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
BDEPEND="
	test? ( dev-python/pytest-xdist[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/${P}-matplotlib-3.7.patch
)

distutils_enable_tests pytest

src_test() {
	cat > matplotlibrc <<- EOF || die
		backend : Agg
	EOF

	distutils-r1_src_test
}

python_test() {
	epytest -n "$(makeopts_jobs)"
}
