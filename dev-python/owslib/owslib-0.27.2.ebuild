# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Library for client programming with Open Geospatial Consortium web service"
HOMEPAGE="https://geopython.github.io/OWSLib/"
SRC_URI="
	https://github.com/geopython/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/OWSLib-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="test"
PROPERTIES="test_network"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="test? ( dev-python/pillow[${PYTHON_USEDEP}] )"

EPYTEST_DESELECT=(
	tests/test_ogcapi_features_pygeoapi.py::test_ogcapi_features_pygeoapi
)

distutils_enable_tests pytest

src_prepare() {
	sed -e '/addopts/d' -i tox.ini || die
	distutils-r1_src_prepare
}
