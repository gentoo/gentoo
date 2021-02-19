# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit cmake distutils-r1

DESCRIPTION="AST-based Python refactoring library"
HOMEPAGE="https://pybind11.readthedocs.io/en/stable/"
SRC_URI="https://github.com/pybind/pybind11/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	dev-cpp/eigen:3
"

distutils_enable_tests pytest

python_prepare_all() {
	export PYBIND11_USE_CMAKE=1

	# broken with scipy-1.4.1
	sed -i -e 's:test_sparse:_&:' tests/test_eigen.py || die

	cmake_src_prepare
	distutils-r1_python_prepare_all
}

python_configure() {
	local mycmakeargs=(
		# disable forced lto
		-DPYBIND11_LTO_CXX_FLAGS=
		-DPYBIND11_INSTALL=ON
		-DPYBIND11_TEST=$(usex test)
	)
	cmake_src_configure
}

python_compile() {
	distutils-r1_python_compile
	# Compilation only does anything for tests
	use test && cmake_src_compile
}

python_test() {
	cmake_build check
}

python_install() {
	distutils-r1_python_install
	cmake_src_install
}
