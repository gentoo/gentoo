# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7..9} pypy3 )
inherit distutils-r1

DESCRIPTION="Run unittests or fail if no tests were found"
HOMEPAGE="https://github.com/mgorny/unittest-or-fail/"
SRC_URI="
	https://github.com/mgorny/unittest-or-fail/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-macos"

# Warning: do not use distutils_enable_tests to avoid a circular
# dependency on itself!
python_test() {
	"${EPYTHON}" -m unittest -v test/test_unittest_or_fail.py ||
		die "Tests failed with ${EPYTHON}"
}
