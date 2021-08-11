# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 virtualx

DESCRIPTION="Convert matplotlib figures into TikZ/PGFPlots"
HOMEPAGE="https://github.com/nschloe/tikzplotlib"
SRC_URI="
	https://github.com/nschloe/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-text/texlive[extra]
	dev-python/matplotlib[latex,${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/exdown[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/mock

python_test() {
	local -x MPLBACKEND=Agg
	local deselect=(
		tests/test_barchart_errorbars.py::test
		tests/test_colorbars.py::test
		tests/test_fillstyle.py::test
	)

	virtx epytest ${deselect[@]/#/--deselect }
}
