# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{9..11} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Pure Python read/write support for ESRI Shapefile format"
HOMEPAGE="https://pypi.org/project/pyshp/"
# pypi tarballs are missing test data
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/GeospatialPython/${PN}/archive/${PV}.tar.gz -> ${P}..gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	epytest test_shapefile.py -m "not network" || die
}
