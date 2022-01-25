# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake

inherit cmake-multilib llvm

DESCRIPTION="Multi-Level IR Compiler Framework for LLVM"
HOMEPAGE="https://mlir.llvm.org/"
SRC_URI=" https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/llvm-13.0.0.src.tar.gz -> llvmorg-13.0.0.tar.gz"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT"
SLOT="13"
KEYWORDS="~amd64"

DEPEND="
	sys-devel/llvm:13=[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

LLVM_MAX_SLOT=13

src_unpack() {
	unpack llvmorg-13.0.0.tar.gz
	mv "${WORKDIR}/llvm-project-llvmorg-13.0.0/mlir" "${WORKDIR}/${P}"
}

multilib_src_configure() {
	local mycmakeargs=(
		-GNinja
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DLLVM_LINK_LLVM_DYLIB:BOOL=ON
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/lib64/cmake/llvm/"
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DMLIR_LINK_MLIR_DYLIB=ON
		-DLLVM_BUILD_TOOLS=ON
		-DLLVM_BUILD_UTILS=ON
		-DLLVM_ENABLE_PIC=ON
		-DMLIR_INCLUDE_TESTS=OFF
		-Wno-dev
		)
	cmake_src_configure
}
