# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A fake file system that mocks the Python file system modules"
HOMEPAGE="
	https://github.com/jmcgeheeiv/pyfakefs/
	https://pypi.org/project/pyfakefs/
"
SRC_URI="
	https://github.com/jmcgeheeiv/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local EPYTEST_DESELECT=()

	[[ ${EPYTHON} == python3.11 ]] && EPYTEST_DESELECT+=(
		pyfakefs/pytest_tests/pytest_plugin_test.py::test_pause_resume
		pyfakefs/pytest_tests/pytest_plugin_test.py::test_pause_resume_contextmanager
		pyfakefs/tests/fake_filesystem_unittest_test.py::PauseResumeTest
		pyfakefs/tests/fake_filesystem_unittest_test.py::PauseResumePatcherTest
		pyfakefs/tests/fake_tempfile_test.py::FakeTempfileModuleTest::test_named_temporary_file
		pyfakefs/tests/fake_tempfile_test.py::FakeTempfileModuleTest::test_named_temporary_file_no_delete
		pyfakefs/tests/fake_tempfile_test.py::FakeTempfileModuleTest::test_temporary_file
		pyfakefs/tests/fake_tempfile_test.py::FakeTempfileModuleTest::test_temporay_file_with_dir
	)

	epytest -p pyfakefs.pytest_plugin
}
