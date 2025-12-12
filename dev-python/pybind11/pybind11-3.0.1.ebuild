# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=scikit-build-core
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit cmake distutils-r1

MY_P=${P/_}
DESCRIPTION="AST-based Python refactoring library"
HOMEPAGE="
	https://pybind11.readthedocs.io/en/stable/
	https://github.com/pybind/pybind11/
	https://pypi.org/project/pybind11/
"
SRC_URI="
	https://github.com/pybind/pybind11/archive/v${PV/_}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"

RDEPEND="
	dev-cpp/eigen:=
"
BDEPEND="
	test? (
		<dev-cpp/catch-3:0
		>=dev-cpp/catch-2.13.9:0
		dev-libs/boost
		dev-python/tomlkit[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	cmake_src_prepare
	distutils-r1_src_prepare
}

python_configure() {
	DISTUTILS_ARGS=(
		# disable forced lto
		-DHAS_FLTO=OFF
		# https://github.com/pybind/pybind11/issues/5087
		-DPYBIND11_FINDPYTHON=OFF
		-DPYBIND11_INSTALL=ON
		-DPYBIND11_TEST=OFF
	)

	local mycmakeargs=(
		"${DISTUTILS_ARGS[@]}"
		-DPYBIND11_TEST=$(usex test)

		# fix missing prefix, https://bugs.gentoo.org/961861
		-Dprefix_for_pc_file="${EPREFIX}"/usr
	)
	cmake_src_configure
}

python_compile() {
	distutils-r1_python_compile
	# Compilation only does anything for tests
	use test && cmake_src_compile
}

python_test() {
	cmake_build cpptest test_cmake_build

	cd "${BUILD_DIR}/tests" || die
	epytest "${S}/tests"
}

python_install() {
	distutils-r1_python_install
	cmake_src_install
}
