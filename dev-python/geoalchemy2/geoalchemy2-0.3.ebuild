# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Geospatial extension to SQLAlchemy with PostGIS support"
HOMEPAGE="https://geoalchemy-2.readthedocs.io/en/latest/"
SRC_URI="https://github.com/geoalchemy/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
# ^^ tarball on pypi is missing tests
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=">=dev-python/sqlalchemy-0.8[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		sci-libs/Shapely[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

RESTRICT="test"
# tests require a running PostgreSQL database

python_test() {
	py.test tests || die
}
