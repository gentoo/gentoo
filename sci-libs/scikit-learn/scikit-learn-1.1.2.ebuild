# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Machine learning library for Python"
HOMEPAGE="https://scikit-learn.org/stable/"
SRC_URI="https://github.com/scikit-learn/scikit-learn/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"
IUSE="examples"

# Fatal Python error: Segmentation fault
RESTRICT="test"

DEPEND="
	virtual/blas:=
	virtual/cblas:=
"
RDEPEND="
	${DEPEND}
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/threadpoolctl[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
# For some reason this wants to use urllib to fetch things from the internet
# distutils_enable_sphinx doc \
# 	dev-python/matplotlib \
# 	dev-python/memory_profiler \
# 	dev-python/numpydoc \
# 	dev-python/pandas \
# 	dev-python/pillow \
# 	dev-python/seaborn \
# 	dev-python/sphinx-gallery \
# 	dev-python/sphinx-prompt \
# 	sci-libs/scikit-image

python_test() {
	# This needs to be run in the install dir
	cd "${WORKDIR}/${P}-${EPYTHON//./_}/install/usr/lib/${EPYTHON}/site-packages/sklearn" || die
	distutils-r1_python_test
}

python_install_all() {
	find "${S}" -name \*LICENSE.txt -delete || die
	distutils-r1_python_install_all
	use examples && dodoc -r examples
}
