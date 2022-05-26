# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="a fake file system that mocks the Python file system modules"
HOMEPAGE="
	https://github.com/jmcgeheeiv/pyfakefs/
	https://pypi.org/project/pyfakefs/
"
SRC_URI="
	https://github.com/jmcgeheeiv/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	[[ ${EPYTHON} == python3.11 ]] && EPYTEST_DESELECT+=(
		# known problem with the test suite
		pyfakefs/tests/fake_filesystem_unittest_test.py::AdditionalSkipNamesModuleTest::test_fake_path_does_not_exist3
		pyfakefs/tests/fake_filesystem_unittest_test.py::AdditionalSkipNamesModuleTest::test_fake_path_does_not_exist7
		pyfakefs/tests/fake_filesystem_unittest_test.py::AdditionalSkipNamesTest::test_fake_path_does_not_exist3
		pyfakefs/tests/fake_filesystem_unittest_test.py::AdditionalSkipNamesTest::test_fake_path_does_not_exist7
		pyfakefs/tests/fake_pathlib_test.py::FakePathlibFileObjectPropertyTest
		pyfakefs/tests/fake_pathlib_test.py::FakePathlibPathFileOperationTest
		pyfakefs/tests/fake_pathlib_test.py::FakePathlibUsageInOsFunctionsTest::test_stat
		pyfakefs/tests/fake_pathlib_test.py::FakePathlibUsageInOsFunctionsTest::test_stat_follow_symlinks
	)

	epytest
}
