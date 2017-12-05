# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

MY_PN="jaraco.util"
DESCRIPTION="General utility modules that supply commonly-used functionality"
HOMEPAGE="https://pypi.python.org/pypi/jaraco.util"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

# The binary calc-prorate is now part of tempora
DEPEND="!!dev-python/tempora[${PYTHON_USEDEP}]
	dev-python/hgtools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}] )
	"
RDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	py.test tests || die "Tests failed under ${EPYTHON}"
}
