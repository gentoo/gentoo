# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Machine learning library for Python"
HOMEPAGE="
	https://scikit-learn.org/stable/
	https://github.com/scikit-learn/scikit-learn/
	https://pypi.org/project/scikit-learn/
"
SRC_URI="
	https://github.com/scikit-learn/scikit-learn/archive/${PV/_}.tar.gz
		-> ${P/_}.gh.tar.gz
"
S=${WORKDIR}/${P/_}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ppc64 ~riscv ~x86 ~arm64-macos ~x64-macos"
IUSE="examples"

DEPEND="
	virtual/blas:=
	virtual/cblas:=
	>=dev-python/numpy-1.24.1:=[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	>=dev-python/joblib-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/threadpoolctl-3.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pythran-0.14.0[${PYTHON_USEDEP}]
	>=dev-python/cython-3.0.10[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

# For some reason this wants to use urllib to fetch things from the internet
# distutils_enable_sphinx doc \
# 	dev-python/matplotlib \
# 	dev-python/memory-profiler \
# 	dev-python/numpydoc \
# 	dev-python/pandas \
# 	dev-python/pillow \
# 	dev-python/seaborn \
# 	dev-python/sphinx-gallery \
# 	dev-python/sphinx-prompt \
# 	dev-python/scikit-image

python_test() {
	local EPYTEST_DESELECT=(
		# TODO: floating-point problems
		gaussian_process/kernels.py::sklearn.gaussian_process.kernels.ExpSineSquared
	)

	case ${ARCH} in
		ppc64)
			EPYTEST_DESELECT+=(
				# TODO
				ensemble/_weight_boosting.py::sklearn.ensemble._weight_boosting.AdaBoostRegressor
			)
	esac

	rm -rf sklearn || die
	epytest --pyargs sklearn
}

python_install_all() {
	distutils-r1_python_install_all
	use examples && dodoc -r examples
}
