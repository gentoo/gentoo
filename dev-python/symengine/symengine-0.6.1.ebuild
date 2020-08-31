# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1

MYP=${PN}.py-${PV}

DESCRIPTION="Python wrappers to the symengine C++ library"
HOMEPAGE="https://github.com/symengine/symengine.py"
SRC_URI="https://github.com/symengine/symengine.py/archive/v${PV}.tar.gz -> ${MYP}.tar.gz"
S="${WORKDIR}/${MYP}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-util/cmake
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/sympy[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	>=sci-libs/symengine-0.6
"

distutils_enable_tests pytest

src_prepare() {
	default

	# Don't install tests
	> "${S}/symengine/tests/CMakeLists.txt" || die
}

python_test() {
	cd "${BUILD_DIR}" || die
	pytest -vv || die "Tests failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install
	python_optimize
}

python_install_all() {
	distutils-r1_python_install_all
	python_optimize

	rm "${ED}"/usr/share/doc/${PF}/README.md || die
	newdoc README.md ${PN}.py.md
}
