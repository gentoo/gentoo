# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_P=${PN}.py-${PV}
DESCRIPTION="Python wrappers to the symengine C++ library"
HOMEPAGE="https://github.com/symengine/symengine.py/"
SRC_URI="
	https://github.com/symengine/symengine.py/archive/v${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

BDEPEND="
	dev-util/cmake
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/sympy[${PYTHON_USEDEP}]
	)
"
# See bug #786582 for symengine constraint
# See also https://github.com/symengine/symengine.py/blob/master/symengine_version.txt
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	>=sci-libs/symengine-$(ver_cut 1-2):=
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

# the C library installs the same docs
DOCS=()

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest
}

python_install() {
	distutils-r1_python_install
	python_optimize
}
