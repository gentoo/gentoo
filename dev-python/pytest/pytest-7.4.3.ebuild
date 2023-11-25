# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{10..12} pypy3 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )

inherit distutils-r1 multiprocessing pypi

DESCRIPTION="Simple powerful testing with Python"
HOMEPAGE="
	https://pytest.org/
	https://github.com/pytest-dev/pytest/
	https://pypi.org/project/pytest/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/iniconfig[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-4.0.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pluggy-0.12[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/exceptiongroup-1.0.0_rc8[${PYTHON_USEDEP}]
		>=dev-python/tomli-1.0.0[${PYTHON_USEDEP}]
	' 3.{9..10})
"
BDEPEND="
	>=dev-python/setuptools-scm-6.2.3[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/argcomplete[${PYTHON_USEDEP}]
			>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
			>=dev-python/hypothesis-3.56[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			>=dev-python/pygments-2.7.2[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			dev-python/xmlschema[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
	)
"

PATCHES=(
	# https://github.com/pytest-dev/pytest/pull/11638
	"${FILESDIR}/${P}-no-color.patch"
)

src_test() {
	# workaround new readline defaults
	echo "set enable-bracketed-paste off" > "${T}"/inputrc || die
	local -x INPUTRC="${T}"/inputrc
	distutils-r1_src_test
}

python_test() {
	if ! has "${EPYTHON}" "${PYTHON_TESTED[@]/_/.}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x COLUMNS=80

	local EPYTEST_DESELECT=(
		# broken by epytest args
		testing/test_warnings.py::test_works_with_filterwarnings

		# tend to be broken by random pytest plugins
		# (these tests patch PYTEST_DISABLE_PLUGIN_AUTOLOAD out)
		testing/test_helpconfig.py::test_version_less_verbose
		testing/test_helpconfig.py::test_version_verbose
		testing/test_junitxml.py::test_random_report_log_xdist
		testing/test_junitxml.py::test_runs_twice_xdist
		testing/test_terminal.py::TestProgressOutputStyle::test_xdist_normal
		testing/test_terminal.py::TestProgressOutputStyle::test_xdist_normal_count
		testing/test_terminal.py::TestProgressOutputStyle::test_xdist_verbose
		testing/test_terminal.py::TestProgressWithTeardown::test_xdist_normal
		testing/test_terminal.py::TestTerminalFunctional::test_header_trailer_info
		testing/test_terminal.py::TestTerminalFunctional::test_no_header_trailer_info

		# unstable with xdist
		testing/test_terminal.py::TestTerminalFunctional::test_verbose_reporting_xdist

		# TODO (XPASS)
		testing/test_debugging.py::TestDebuggingBreakpoints::test_pdb_not_altered
		testing/test_debugging.py::TestPDB::test_pdb_interaction_capturing_simple
		testing/test_debugging.py::TestPDB::test_pdb_interaction_capturing_twice
		testing/test_debugging.py::TestPDB::test_pdb_with_injected_do_debug
		testing/test_debugging.py::test_pdb_suspends_fixture_capturing

		# setuptools warnings
		testing/acceptance_test.py::TestInvocationVariants::test_cmdline_python_namespace_package
	)

	[[ ${EPYTHON} == pypy3 ]] && EPYTEST_DESELECT+=(
		# regressions on pypy3.9
		# https://github.com/pytest-dev/pytest/issues/9787
		testing/test_skipping.py::test_errors_in_xfail_skip_expressions
		testing/test_unraisableexception.py
	)

	epytest -p xdist -n "$(makeopts_jobs)"
}
