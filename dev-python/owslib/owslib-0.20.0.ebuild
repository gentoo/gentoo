# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Library for client programming with Open Geospatial Consortium web service"
HOMEPAGE="https://geopython.github.io/OWSLib/"
SRC_URI="https://github.com/geopython/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/OWSLib-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pyproj[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

RESTRICT="test" # tests require WAN access

PATCHES=( "${FILESDIR}/${P}-no-privacybreach.patch" )

python_test() {
	"${EPYTHON}" "${S}/setup.py" test || die
}
