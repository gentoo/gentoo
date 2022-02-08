# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake llvm llvm.org multilib multilib-minimal \
	prefix python-single-r1 toolchain-funcs

DESCRIPTION="Multi-Level IR Compiler Framework for LLVM"
HOMEPAGE="https://mlir.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT"
SLOT="$(ver_cut 1)"
KEYWORDS=""
IUSE="test"

RDEPEND="
	sys-devel/llvm:${SLOT}=[${MULTILIB_USEDEP}]
	sys-devel/clang:${SLOT}=[${MULTILIB_USEDEP}]
	sys-devel/lld
	"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/llvm:${SLOT}=[${MULTILIB_USEDEP}]
	sys-devel/clang:${SLOT}=[${MULTILIB_USEDEP}]
	sys-devel/lld
"
#RDEPEND="${DEPEND}"

RESTRICT="!test? ( test )"

LLVM_COMPONENTS=( mlir cmake )
LLVM_MANPAGES=build
llvm.org_set_globals

pkg_setup() {
	LLVM_MAX_SLOT=${SLOT} llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	# create extra parent dir for relative CLANG_RESOURCE_DIR access
	mkdir -p x/y || die
	BUILD_DIR=${WORKDIR}/x/y/mlir

	llvm.org_src_prepare
}

multilib_src_configure() {

	local mycmakeargs=(
		-GNinja
		-DLLVM_CMAKE_PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/llvm"
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
		-DBUILD_SHARED_LIBS=OFF
		-DLLVM_LINK_LLVM_DYLIB:BOOL=ON
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/llvm/"
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DMLIR_LINK_MLIR_DYLIB=ON
		-DLLVM_BUILD_TOOLS=ON
		-DLLVM_BUILD_UTILS=ON
		-DLLVM_ENABLE_PIC=ON
		-DMLIR_INCLUDE_TESTS=$(usex test)
		-DLLVM_DISTRIBUTION_COMPONENTS=$(get_distribution_components)
		-DLLVM_TARGETS_TO_BUILD="X86;NVPTX;AMDGPU"
		-Wno-dev
	)
	cmake_src_configure
}

multilib_src_compile() {
	cmake_build
}

multilib_src_install() {
	DESTDIR=${D} cmake_build install
}
