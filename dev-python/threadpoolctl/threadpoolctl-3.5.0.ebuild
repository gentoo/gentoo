# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Limit the number of threads used in native libs that have their own threadpool"
HOMEPAGE="
	https://github.com/joblib/threadpoolctl/
	https://pypi.org/project/threadpoolctl/
"
SRC_URI="
	https://github.com/joblib/threadpoolctl/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~riscv x86 ~arm64-macos ~x64-macos"

BDEPEND="
	test? (
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Asserts against a hardcoded list of CPUs.  Either we skip it
		# or file bugs about missing architectures until upstream realizes
		# how bad idea that were.
		tests/test_threadpoolctl.py::test_architecture
		# This test fails if the Python executable (or any library that it
		# links to) uses OpenMP.  This can particularly be the case with
		# CPython 3.12 that links to app-crypt/libb2.
		# https://github.com/joblib/threadpoolctl/issues/146
		tests/test_threadpoolctl.py::test_command_line_empty
	)

	# see continuous_integration/build_test_ext.sh
	if [[ ! -f tests/_pyMylib/my_threaded_lib.so ]]; then
		pushd tests/_pyMylib >/dev/null || die
		$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -fPIC -shared \
			-o my_threaded_lib.so my_threaded_lib.c || die
		popd >/dev/null || die
	fi

	pushd tests/_openmp_test_helper >/dev/null || die
	"${EPYTHON}" setup_inner.py build_ext -i || die
	"${EPYTHON}" setup_outer.py build_ext -i || die
	"${EPYTHON}" setup_nested_prange_blas.py build_ext -i || die
	popd >/dev/null || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
