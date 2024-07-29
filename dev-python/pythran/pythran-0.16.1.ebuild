# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="Ahead of Time compiler for numeric kernels"
HOMEPAGE="
	https://pypi.org/project/pythran/
	https://github.com/serge-sans-paille/pythran/
"
SRC_URI="
	https://github.com/serge-sans-paille/pythran/archive/${PV/_p/.post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-libs/boost
	dev-cpp/xsimd
	=dev-python/beniget-0.4*[${PYTHON_USEDEP}]
	=dev-python/gast-0.5*[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/ply-3.4[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-libs/boost
		dev-cpp/xsimd
	)
"
BDEPEND="
	test? (
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		virtual/cblas
		!!dev-python/setuptools-declarative-requirements
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_configure() {
	# vendored C++ headers -- use system copies
	rm -r pythran/{boost,xsimd} || die

	if use test ; then
		# https://bugs.gentoo.org/916461
		sed -i \
			-e 's|blas=blas|blas=cblas|' \
			-e 's|libs=|libs=cblas|' \
			pythran/pythran-*.cfg || die
	fi
}

python_test() {
	local -x COLUMNS=80
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1

	local EPYTEST_DESELECT=(
		# TODO
		pythran/tests/test_numpy_ufunc_unary.py::TestNumpyUFuncUnary::test_signbit0
	)

	if has_version ">=dev-python/numpy-2[${PYTHON_USEDEP}]"; then
		case ${EPYTHON} in
			pypy3)
				EPYTEST_DESELECT+=(
					pythran/tests/test_distutils.py::TestDistutils::test_setup_bdist_install3
					pythran/tests/test_distutils.py::TestDistutils::test_setup_build3
					pythran/tests/test_distutils.py::TestDistutils::test_setup_sdist_install
					pythran/tests/test_distutils.py::TestDistutils::test_setup_sdist_install2
					pythran/tests/test_distutils.py::TestDistutils::test_setup_sdist_install3
					pythran/tests/test_exception.py::TestException::test_multiple_tuple_exception_register
					pythran/tests/test_ndarray.py::TestNdarray::test_ndarray_fancy_indexing1
					pythran/tests/test_numpy_fft.py::TestNumpyFFTN::test_fftn_1
					pythran/tests/test_numpy_func0.py::TestNumpyFunc0::test_ravel0
					pythran/tests/test_numpy_func3.py::TestNumpyFunc3::test_list_imag0
					pythran/tests/test_numpy_random.py::TestNumpyRandom::test_numpy_uniform_size_int
					pythran/tests/test_set.py::TestSet::test_fct_symmetric_difference_update
				)
				;;
			python3.13)
				EPYTEST_DESELECT+=(
					# repr() differences?
					pythran/tests/test_xdoc.py::TestDoctest::test_tutorial
					pythran/tests/test_xdoc.py::TestDoctest::test_utils
				)
		esac
	fi

	epytest
}
