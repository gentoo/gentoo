# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} pypy{,3} )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="a fake file system that mocks the Python file system modules"
HOMEPAGE="https://github.com/jmcgeheeiv/pyfakefs/ https://pypi.org/project/pyfakefs/"
SRC_URI="https://github.com/jmcgeheeiv/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

COMMON_DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/pyfakefs-3.4.3-tests.patch )

python_test() {
	"${PYTHON}" -m ${PN}.tests.all_tests || die "tests failed under ${EPYTHON}"
}
