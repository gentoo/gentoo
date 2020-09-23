# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

DISTUTILS_USE_SETUPTOOLS=rdepend
inherit eutils distutils-r1

DESCRIPTION="NumPy aware dynamic Python compiler using LLVM"
HOMEPAGE="https://numba.pydata.org/
	https://github.com/numba"
SRC_URI="https://github.com/numba/numba/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp threads"

DEPEND="
	>=dev-python/llvmlite-0.34.0[${PYTHON_USEDEP}]
	<=dev-python/llvmlite-0.35.0
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	threads? ( dev-cpp/tbb )
"
RDEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/scipy[${PYTHON_USEDEP}]
	)
"

DISTUTILS_IN_SOURCE_BUILD=1
distutils_enable_tests unittest

# doc system is another huge mess, skip it
PATCHES=(
	"${FILESDIR}/${P}-skip_tests.patch"
)

pkg_setup() {
	export NUMBA_DISABLE_TBB=$(usex threads 0 1) \
		TBBROOT="${EPREFIX}/usr" \
		NUMBA_DISABLE_OPENMP=$(usex openmp 0 1)
}

# https://numba.pydata.org/numba-doc/latest/developer/contributing.html?highlight=test#running-tests
python_test() {
	distutils_install_for_testing
	${EPYTHON} setup.py build_ext --inplace || die \
		"${EPYTHON} failed to build_ext"
	${EPYTHON} runtests.py || die \
		"${EPYTHON} failed unittests"
}

# https://numba.pydata.org/numba-doc/latest/user/installing.html
python_install_all() {
	export NUMBA_DISABLE_TBB=$(usex threads 0 1) \
		TBBROOT="${EPREFIX}/usr" \
		NUMBA_DISABLE_OPENMP=$(usex openmp 0 1)
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "support for linear algebra" sci-libs/scipy
	optfeature "compile cuda code" dev-util/nvidia-cuda-sdk
}
