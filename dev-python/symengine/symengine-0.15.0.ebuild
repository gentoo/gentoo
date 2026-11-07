# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=scikit-build-core
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python wrappers to the symengine C++ library"
HOMEPAGE="
	https://github.com/symengine/symengine.py/
	https://pypi.org/project/symengine/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# Bindings implicitly use symengine's dependencies.
IUSE="boost ecm +flint llvm +mpc +mpfr primesieve tcmalloc"

BDEPEND="
	dev-build/cython-cmake
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/sympy[${PYTHON_USEDEP}]
	)
"
# See bug #786582 for symengine constraint
# See also https://github.com/symengine/symengine.py/blob/master/symengine_version.txt
DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	=sci-libs/symengine-$(ver_cut 1-2)*[boost=,ecm=,flint=,llvm=,mpc=,mpfr=,primesieve=,tcmalloc=]
"
RDEPEND="
	${DEPEND}
"

# The C library installs the same docs
DOCS=()

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest
}
