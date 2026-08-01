# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="library with cross-python path, ini-parsing, io, code, log facilities"
HOMEPAGE="
	https://py.readthedocs.io/
	https://github.com/pytest-dev/py/
	https://pypi.org/project/py/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"

RDEPEND="
	dev-python/apipkg[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	rm -r py/_vendored_packages || die
	# remove unnecessary modules to reduce attack surface
	rm -r py/{_io,_log} || die
	rm py/{_std,_xmlgen}.py || die
	rm py/_code/{_*,assertion,source}.py || die
	rm py/_path/{cacheutil,svn*}.py || die
	rm py/_process/{cmdexec,killproc}.py || die
	rm testing/path/conftest.py || die
}

python_test() {
	local tests=(
		# a small subset of tests for stuff we didn't remove
		testing/process/test_forkedfunc.py
		testing/path/test_local.py
		testing/root/test_builtin.py
		testing/root/test_error.py
	)

	local EPYTEST_DESELECT=(
		# require removed modules
		testing/path/test_local.py::TestLocalPath::test_init_from_path
		testing/path/test_local.py::TestExecution::test_sysexec_failing
		testing/process/test_forkedfunc.py::test_execption_in_func
		# broken ancient pytest syntax
		testing/path/test_local.py::TestLocalPath::test_listdir
		testing/path/test_local.py::TestLocalPath::test_relto_wrong_type
		testing/root/test_builtin.py::test_print_simple
		testing/root/test_builtin.py::test_reraise
	)

	epytest "${tests[@]}"
}
