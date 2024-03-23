# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

PLOTLY_PV="5.13.0"

DESCRIPTION="Browser-based graphing library for Python"
HOMEPAGE="https://plotly.com/python/"
SRC_URI="https://github.com/plotly/plotly.py/archive/refs/tags/v${PLOTLY_PV}.tar.gz -> plotly.py-${PLOTLY_PV}.gh.tar.gz"
S="${WORKDIR}/plotly.py-${PLOTLY_PV}/packages/python/${PN}"
# PyPI tarball does not include the tests, sources are in the same repo as plotly.

PROPERTIES="test_network"
RESTRICT="test"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/plotly[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/retrying[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/decorator[${PYTHON_USEDEP}]
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# URL is somehow wrong
	"chart_studio/tests/test_core/test_tools/test_get_embed.py::test_get_valid_embed"
	"chart_studio/tests/test_core/test_tools/test_get_embed.py::TestGetEmbed::test_get_embed_url_with_share_key"
	"chart_studio/tests/test_optional/test_matplotlylib/test_plot_mpl.py::PlotMPLTest::test_update"
	"chart_studio/tests/test_plot_ly/test_spectacle_presentation/test_spectacle_presentation.py::TestPresentation::test_expected_pres"
)

# There are sphinx docs but we are missing a bunch of dependencies.
# distutils_enable_sphinx ../../../doc/apidoc
distutils_enable_tests pytest
