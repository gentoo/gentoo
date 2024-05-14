# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{10..13} pypy3 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )

inherit distutils-r1 pypi

DESCRIPTION="Simple powerful testing with Python"
HOMEPAGE="
	https://pytest.org/
	https://github.com/pytest-dev/pytest/
	https://pypi.org/project/pytest/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/iniconfig[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	<dev-python/pluggy-2[${PYTHON_USEDEP}]
	>=dev-python/pluggy-1.5.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/exceptiongroup-1.0.0_rc8[${PYTHON_USEDEP}]
		>=dev-python/tomli-1[${PYTHON_USEDEP}]
	' 3.10)
	!!<=dev-python/flaky-3.7.0-r5
"
BDEPEND="
	>=dev-python/setuptools-scm-6.2.3[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/argcomplete[${PYTHON_USEDEP}]
			>=dev-python/attrs-19.2[${PYTHON_USEDEP}]
			>=dev-python/hypothesis-3.56[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			>=dev-python/pygments-2.7.2[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			dev-python/xmlschema[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
	)
"

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

		# times out
		testing/test_debugging.py::TestPDB::test_pdb_interaction_exception
		testing/test_debugging.py::TestPDB::test_pdb_with_caplog_on_pdb_invocation
	)

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# regressions on pypy3.9
				# https://github.com/pytest-dev/pytest/issues/9787
				testing/test_skipping.py::test_errors_in_xfail_skip_expressions
				testing/test_unraisableexception.py
			)
			;;
		python3.13)
			EPYTEST_DESELECT+=(
				# regressions reproduced via `tox -e py313`
				# https://github.com/pytest-dev/pytest/issues/12323
				testing/code/test_excinfo.py::TestFormattedExcinfo::test_repr_traceback_recursion
				testing/code/test_excinfo.py::TestTraceback_f_g_h::test_traceback_recursion_index
				testing/code/test_excinfo.py::test_exception_repr_extraction_error_on_recursion
				testing/code/test_source.py::test_getfslineno
				testing/test_collection.py::TestSession::test_collect_custom_nodes_multi_id
				testing/test_collection.py::TestSession::test_collect_protocol_single_function
				testing/test_collection.py::TestSession::test_collect_subdir_event_ordering
				testing/test_collection.py::TestSession::test_collect_two_commandline_args
				testing/test_doctest.py::TestDoctests::test_doctest_linedata_on_property
				testing/test_doctest.py::TestDoctests::test_doctest_unexpected_exception
				testing/test_legacypath.py::test_testdir_makefile_ext_none_raises_type_error

				# TODO?
				testing/code/test_excinfo.py::test_excinfo_no_sourcecode

				# more weird timeouts
				testing/test_debugging.py::TestPDB::test_pdb_used_outside_test
				testing/test_debugging.py::TestPDB::test_pdb_used_in_generate_tests
			)
			;;
	esac

	local EPYTEST_XDIST=1
	epytest
}
