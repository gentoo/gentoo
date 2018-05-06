# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy{,3} )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="a fake file system that mocks the Python file system modules"
HOMEPAGE="https://github.com/jmcgeheeiv/pyfakefs/ https://pypi.org/project/pyfakefs"
SRC_URI="https://github.com/jmcgeheeiv/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-tests.patch )

python_test() {
	"${PYTHON}" tests/all_tests.py || die "tests failed under ${EPYTHON}"
}
