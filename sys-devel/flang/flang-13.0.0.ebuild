# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib llvm python-single-r1

DESCRIPTION="Flang is a ground-up implementation of a Fortran front end written in modern C++"
## In order to compile this package you need sys-devel/mlir package
HOMEPAGE=" https://github.com/llvm/llvm-project/tree/main/flang"
SRC_URI=" https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/flang-13.0.0.src.tar.xz -> ${P}.tar.xz"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT"
SLOT="13"
IUSE="doc test +system-llvm"
KEYWORDS="~amd64"

DEPEND="
	>=sys-devel/clang-13.0.0:13=[static-analyzer,${MULTILIB_USEDEP}]
	sys-devel/llvm:13=[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}"

BDEPEND="
	doc? (
		dev-python/sphinx
		app-doc/doxygen[dot]
	)
	test? (
		dev-python/lit
	)
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

LLVM_MAX_SLOT=13

src_unpack() {
	unpack ${P}.tar.xz
	mv "${WORKDIR}/${P}.src" "${WORKDIR}/${P}"
}

PATCHES=(
	"${FILESDIR}"/flang-Link-against-libclang-cpp.so.patch
	"${FILESDIR}"/flang-PATCH-flang-Disable-use-of-sphinx_markdown_tables.patch
)

pkg_setup() {
	use system-llvm && llvm_pkg_setup
	use system-llvm &&  export CC=clang
	use system-llvm &&  export CXX=clang++
	use system-llvm &&  export AR=llvm-ar
	use system-llvm &&  export LD=lld
	use system-llvm &&  export RANLIB=llvm-ranlib
	use system-llvm &&  export NM=llvm-nm
}

multilib_src_configure() {
	local mycmakeargs=(
		-GNinja
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
		-DMLIR_TABLEGEN_EXE="${EPREFIX}/usr/lib/llvm/${SLOT}/bin/mlir-tblgen"
		-DCMAKE_BUILD_TYPE=Release
		-DCLANG_DIR="${EPREFIX}/usr/lib/llvm/${SLOT}/lib64/cmake/clang/"
		-DMLIR_DIR="${EPREFIX}/usr/lib/llvm/${SLOT}/lib64/cmake/mlir/"
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DLLVM_LINK_LLVM_DYLIB:BOOL=ON
		-DLLVM_ENABLE_THREADS=ON

		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/lib64/cmake/llvm/"
		-Wno-dev
		)
		use system-llvm &&  mycmakeargs+=(
			-DLLVM_ENABLE_LLD=ON
		)
		use doc &&  mycmakeargs+=(
			-DLLVM_ENABLE_SPHINX:BOOL=ON
			-DLLVM_ENABLE_DOXYGEN=ON
			-DFLANG_INCLUDE_DOCS=ON
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
			-DSPHINX_EXECUTABLE=/usr/bin/sphinx-build
		)
		use test && mycmakeargs+=(
				-DLLVM_BUILD_TESTS=ON
				-DLLVM_EXTERNAL_LIT=/usr/bin//lit
				-DPython3_EXECUTABLE="${PYTHON}"
		)
	cmake_src_configure
}

multilib_src_compile() {
	export LD_LIBRARY_PATH="${S}_build-abi_x86_64.amd64/lib"
	cmake_build
	ninja doxygen-flang
}
