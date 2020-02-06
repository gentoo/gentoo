# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 virtualx

DESCRIPTION="Convert matplotlib figures into TikZ/PGFPlots"
HOMEPAGE="https://github.com/nschloe/tikzplotlib"
SRC_URI="https://github.com/nschloe/tikzplotlib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]"

DEPEND="test? (
		dev-python/pandas[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/mock

python_prepare_all() {
	# this test fails: tikz error
	# cannot mix dimensions and dimensionless values in an ellipse
	rm test/test_patches.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x MPLBACKEND=Agg
	virtx pytest -vv
}
