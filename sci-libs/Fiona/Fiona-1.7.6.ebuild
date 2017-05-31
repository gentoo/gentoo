# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_{3,4,5,6}} )

inherit distutils-r1

DESCRIPTION="OGR's neat, nimble, no-nonsense API"
HOMEPAGE="https://pypi.python.org/pypi/Fiona"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=sci-libs/gdal-1.8
	dev-python/click[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/cligj[${PYTHON_USEDEP}]
		dev-python/munch[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}"/scriptname-${PV}.patch )

python_test() {
	esetup.py test
}
