# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Machine learning library for Python"
HOMEPAGE="
	https://scikit-learn.org/stable/
	https://github.com/scikit-learn/scikit-learn/
	https://pypi.org/project/scikit-learn/
"
SRC_URI="
	https://github.com/scikit-learn/scikit-learn/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86 ~arm64-macos ~x64-macos"
IUSE="examples"

DEPEND="
	virtual/blas:=
	virtual/cblas:=
	>=dev-python/numpy-1.19.5:=[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	>=dev-python/joblib-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/threadpoolctl-3.1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pythran-0.14.0[${PYTHON_USEDEP}]
	>=dev-python/cython-3.0.10[${PYTHON_USEDEP}]
"

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
	rm -rf sklearn || die
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest --pyargs sklearn
}

python_install_all() {
	find "${S}" -name \*LICENSE.txt -delete || die
	distutils-r1_python_install_all
	use examples && dodoc -r examples
}
