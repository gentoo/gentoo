# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Statistical data visualization"
HOMEPAGE="https://seaborn.pydata.org https://github.com/mwaskom/seaborn"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/statsmodels[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_test() {
	cat > matplotlibrc <<- EOF || die
		backend : Agg
	EOF
	distutils-r1_src_test
}
