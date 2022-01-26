# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake

inherit cmake-multilib llvm

DESCRIPTION="Multi-Level IR Compiler Framework for LLVM"
HOMEPAGE="https://mlir.llvm.org/"
SRC_URI="https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/llvm-project-${PV}.src.tar.xz"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT"
SLOT="13"
KEYWORDS="~amd64"
IUSE="test +clang"

DEPEND="
	sys-devel/llvm:13=[${MULTILIB_USEDEP}]
	clang? ( sys-devel/clang:13=[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"
RESTRICT="!test? ( test )"

LLVM_MAX_SLOT=13

src_unpack() {
	unpack llvm-project-${PV}.src.tar.xz
	mv "${WORKDIR}/llvm-project-${PV}.src/mlir" "${WORKDIR}/${P}" || die
}

pkg_setup() {
	use system-llvm && llvm_pkg_setup
	if use clang ; then
		export CC=clang
		export CXX=clang++
		export AR=llvm-ar
		export LD=lld
		export RANLIB=llvm-ranlib
		export NM=llvm-nm
	fi
}

multilib_src_configure() {
	local mycmakeargs=(
		-GNinja
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DLLVM_LINK_LLVM_DYLIB:BOOL=ON
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/llvm/"
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DMLIR_LINK_MLIR_DYLIB=ON
		-DLLVM_BUILD_TOOLS=ON
		-DLLVM_BUILD_UTILS=ON
		-DLLVM_ENABLE_PIC=ON
		-DMLIR_INCLUDE_TESTS=$(usex test)
		-Wno-dev
	)
	cmake_src_configure
}
