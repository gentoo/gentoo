# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_FULLY_TESTED=( python3_{11..14} )
PYTHON_TESTED=( "${PYTHON_FULLY_TESTED[@]}" pypy3_11 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" python3_{13,14}t )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 multiprocessing pypi toolchain-funcs

DESCRIPTION="A Python to C compiler"
HOMEPAGE="
	https://cython.org/
	https://github.com/cython/cython/
	https://pypi.org/project/Cython/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test test-full"
RESTRICT="!test? ( test )"

BDEPEND="
	${RDEPEND}
	test? (
		test-full? (
			$(python_gen_cond_dep '
				dev-python/numpy[${PYTHON_USEDEP}]
			' "${PYTHON_FULLY_TESTED[@]}")
		)
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.29.23-pythran-parallel-install.patch"
)

distutils_enable_sphinx docs \
	dev-python/jinja2 \
	dev-python/sphinx-issues \
	dev-python/sphinx-tabs

python_compile() {
	# Python gets confused when it is in sys.path before build.
	local -x PYTHONPATH=

	if use elibc_musl ; then
		# Workaround for bug #925318
		local -x LDFLAGS="${LDFLAGS} -Wl,-z,stack-size=2097152"
	fi

	distutils-r1_python_compile
}

python_test() {
	# PYTHON_TESTED controls whether we expect the testsuite to
	# pass at all, while PYTHON_FULLY_TESTED allows skipping before
	# numpy is ported (and possibly other deps in future).
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping tests on ${EPYTHON} (xfail)"
		return
	fi

	# Needed to avoid confusing cache tests
	unset CYTHON_FORCE_REGEN

	# uses $(nproc) to additionally parallelize many OpenMP-based jobs,
	# leading to overcommitting
	local -x OMP_NUM_THREADS=1

	tc-export CC

	local testargs=(
		-vv
		-j "$(makeopts_jobs)"
		--work-dir "${BUILD_DIR}"/tests

		--no-examples
		--no-code-style

		# Fails to find embedded.c
		--exclude 'embedded'
		# coverage_installed_pkg needs dev-python/pip and doesn't like
		# 'externally-managed' (bug #927995), but we don't really
		# want automagic test dependencies at all, so just skip
		# unimportant-for-us coverage tests entirely.
		--exclude 'run.coverage*'
		--exclude 'Cython.Coverage'
		# Automagic on dev-python/python-tests, could add this in future
		--exclude 'run.test_exceptions'
		# TODO: Unpackaged dev-python/interpreters-pep-734 (interpreters_backport)
		# This only shows up as a failure with >=3.13.
		--exclude 'subinterpreters_threading_stress_test'

		# The fix for https://github.com/cython/cython/issues/6938
		# changes these tests s.t. they break with our build layout.
		--exclude 'build.depfile*'
	)

	if [[ ${EPYTHON} == pypy3* ]] ; then
		testargs+=(
			# Recursion issue
			--exclude 'run.if_else_expr'
			--exclude 'run.test_patma*'
			# Slight output difference (missing '<')
			--exclude 'run.cpp_exception_ptr_just_handler'

		)
	fi

	# Keep test-full for numpy as it's large and doesn't pass tests itself
	# on niche arches.
	if ! use test-full || ! has "${EPYTHON/./_}" "${PYTHON_FULLY_TESTED[@]}"; then
		testargs+=(
			--exclude 'run.numpy*'
			--exclude 'run.ufunc'
			--exclude 'numpy*'
		)
	fi

	"${PYTHON}" runtests.py "${testargs[@]}" || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGES.rst README.rst ToDo.txt USAGE.txt )
	distutils-r1_python_install_all
}
