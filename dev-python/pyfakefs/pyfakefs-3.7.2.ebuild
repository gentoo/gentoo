# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7,3_8} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="a fake file system that mocks the Python file system modules"
HOMEPAGE="https://github.com/jmcgeheeiv/pyfakefs/ https://pypi.org/project/pyfakefs/"
SRC_URI="https://github.com/jmcgeheeiv/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	"${EPYTHON}" -m pyfakefs.tests.all_tests -v || die "tests failed under ${EPYTHON}"
}
