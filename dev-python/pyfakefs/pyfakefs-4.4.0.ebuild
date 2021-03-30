# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="a fake file system that mocks the Python file system modules"
HOMEPAGE="https://github.com/jmcgeheeiv/pyfakefs/ https://pypi.org/project/pyfakefs/"
SRC_URI="https://github.com/jmcgeheeiv/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

distutils_enable_tests pytest

python_test() {
	"${EPYTHON}" -m pyfakefs.tests.all_tests -v || die "tests failed under ${EPYTHON}"
}
