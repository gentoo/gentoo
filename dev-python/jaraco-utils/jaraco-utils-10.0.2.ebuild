# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/jaraco-utils/jaraco-utils-10.0.2.ebuild,v 1.6 2015/04/08 08:05:19 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_PN="jaraco.util"
DESCRIPTION="General utility modules that supply commonly-used functionality"
HOMEPAGE="http://pypi.python.org/pypi/jaraco.util"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="dev-python/hgtools[${PYTHON_USEDEP}]
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
