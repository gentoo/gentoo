# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

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
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-libs/boost
	dev-cpp/xsimd
	=dev-python/beniget-0.4*[${PYTHON_USEDEP}]
	=dev-python/gast-0.6*[${PYTHON_USEDEP}]
	dev-python/numpy:=[${PYTHON_USEDEP}]
	>=dev-python/ply-3.4[${PYTHON_USEDEP}]
	>=dev-python/setuptools-73.0.1[${PYTHON_USEDEP}]
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

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-numpy-float128-tests.patch
)

src_configure() {
	# vendored C++ headers -- use system copies
	rm -r pythran/{boost,xsimd} || die

	# https://bugs.gentoo.org/916461
	sed -i \
		-e 's|blas=blas|blas=cblas|' \
		-e 's|libs=|libs=cblas|' \
		pythran/pythran-*.cfg || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# multiple extra deps (meson, openblas)
		# also broken on pypy3*
		pythran/tests/test_distutils.py::TestMeson::test_meson_build
	)
	local EPYTEST_IGNORE=(
		pythran/benchmarks
	)

	case ${ARCH} in
		arm)
			EPYTEST_DESELECT+=(
				# TODO
				pythran/tests/test_numpy_fft.py::TestNumpyFFT::test_fft_3d_axis
				pythran/tests/test_numpy_fft.py::TestNumpyFFTN
			)
			;;
	esac

	# can easily fill up ccache with no real benefit
	local -x CCACHE_DISABLE=1
	local -x COLUMNS=80
	epytest
}
