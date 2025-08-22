# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
PYTHON_REQ_USE="threads(+),sqlite(+)"

inherit distutils-r1 multiprocessing pypi

DESCRIPTION="Code coverage measurement for Python"
HOMEPAGE="
	https://coverage.readthedocs.io/en/latest/
	https://github.com/nedbat/coveragepy/
	https://pypi.org/project/coverage/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="+native-extensions"

BDEPEND="
	test? (
		>=dev-python/unittest-mixins-1.4[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( hypothesis pytest-{rerunfailures,xdist} )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_compile() {
	if ! use native-extensions; then
		local -x COVERAGE_DISABLE_EXTENSION=1
	fi

	distutils-r1_python_compile
}

test_tracer() {
	local -x COVERAGE_CORE=${1}
	einfo "  Testing with the ${COVERAGE_CORE} core ..."
	epytest -o addopts= "${@:2}" tests
}

python_test() {
	local EPYTEST_DESELECT=(
		# broken because of pytest plugins explicity loaded
		tests/test_debug.py::ShortStackTest::test_short_stack{,_skip}
		# these expect specific availability of C extension matching
		# COVERAGE_CORE (which breaks testing pytracer on CPython)
		tests/test_cmdline.py::CmdLineStdoutTest::test_version
		tests/test_debug.py::DebugTraceTest::test_debug_sys_ctracer
		# mismatch of expected concurrency in error message
		# TODO: report upstream?
		tests/test_concurrency.py::ConcurrencyTest::test_greenlet
		tests/test_concurrency.py::ConcurrencyTest::test_greenlet_simple_code
		# packaging tests, fragile to setuptools version
		tests/test_setup.py
		# looks like a difference in exit status reporting?
		# https://github.com/nedbat/coveragepy/issues/2008
		tests/test_process.py::ProcessTest::test_save_signal_usr1
	)
	local EPYTEST_IGNORE=(
		# pip these days insists on fetching build deps from Internet
		tests/test_venv.py
	)

	"${EPYTHON}" igor.py zip_mods || die

	local -x COVERAGE_TESTING=True
	# TODO: figure out why they can't be imported inside test env
	local -x COVERAGE_NO_CONTRACTS=1

	local jobs=${EPYTEST_JOBS:-$(makeopts_jobs)}
	local xdist_args=()
	if [[ ${jobs} -gt 1 ]]; then
		# required upstream to avoid cross-test conflicts
		xdist_args+=( --dist=loadgroup )
	fi

	local prev_opt=$(shopt -p nullglob)
	shopt -s nullglob
	local c_ext=( "${BUILD_DIR}/install$(python_get_sitedir)"/coverage/*.so )
	${prev_opt}

	if [[ -n ${c_ext} ]]; then
		cp "${c_ext}" coverage/ || die
		test_tracer ctrace "${xdist_args[@]}"
	fi

	test_tracer pytrace "${xdist_args[@]}"

	case ${EPYTHON} in
		*3.11)
			;;
		*)
			# available since Python 3.12
			test_tracer sysmon "${xdist_args[@]}"
			;;
	esac

	if [[ -n ${c_ext} ]]; then
		rm coverage/*.so || die
	fi
}
