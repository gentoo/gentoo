# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="A fake file system that mocks the Python file system modules"
HOMEPAGE="
	https://github.com/pytest-dev/pyfakefs/
	https://pypi.org/project/pyfakefs/
"
SRC_URI="
	https://github.com/pytest-dev/pyfakefs/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

EPYTEST_PLUGINS=( "${PN}" )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# requires *.dist-info/RECORD file that we're stripping
		pyfakefs/tests/fake_filesystem_test.py::RealFileSystemAccessTest::test_add_package_metadata
		# wants dev-python/openpyxl
		pyfakefs/tests/patched_packages_test.py::TestPatchedPackages::test_read_excel
	)
	local EPYTEST_IGNORE=(
		# test for regression with opentimelineio package
		pyfakefs/pytest_tests/segfault_test.py
		# test for regression with undefined package
		pyfakefs/pytest_tests/pytest_fixture_test.py
	)

	if ! has_version "dev-python/pandas[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			pyfakefs/pytest_tests/pytest_reload_pandas_test.py
		)
	fi

	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				# TODO: this test messes up everything
				pyfakefs/tests/fake_filesystem_unittest_test.py::TestDeprecationSuppression::test_no_deprecation_warning
				# TODO
				pyfakefs/tests/fake_pathlib_test.py::SkipPathlibTest::test_exists
			)
			;;
	esac

	epytest
}
