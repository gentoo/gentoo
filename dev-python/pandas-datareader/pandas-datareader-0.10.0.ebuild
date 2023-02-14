# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1

DESCRIPTION="Pandas DataFrame extraction from a wide range of Internet sources"
HOMEPAGE="https://github.com/pydata/pandas-datareader"
SRC_URI="https://github.com/pydata/pandas-datareader/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.19.2[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	doc? (
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)"
BDEPEND="
	test? ( dev-python/wrapt[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

python_test() {
	local deselect=(
		# looks like minor numpy incompatibility
		pandas_datareader/tests/yahoo/test_yahoo.py::TestYahoo::test_get_data_null_as_missing_data
	)
	epytest pandas_datareader --only-stable --skip-requires-api-key \
		${deselect[@]/#/--deselect }
}
