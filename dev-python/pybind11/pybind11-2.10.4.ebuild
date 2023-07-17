# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit cmake distutils-r1

DESCRIPTION="AST-based Python refactoring library"
HOMEPAGE="
	https://pybind11.readthedocs.io/en/stable/
	https://github.com/pybind/pybind11/
	https://pypi.org/project/pybind11/
"
SRC_URI="
	https://github.com/pybind/pybind11/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

RDEPEND="
	dev-cpp/eigen:3
"
BDEPEND="
	test? (
		>=dev-cpp/catch-2.13.5
		dev-libs/boost
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	export PYBIND11_USE_CMAKE=1
	cmake_src_prepare
	PATCHES=( "${FILESDIR}"/pybind11-2.10.4_macOS-GCC.patch )
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
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	cmake_build check
}

python_install() {
	distutils-r1_python_install
	cmake_src_install
}
