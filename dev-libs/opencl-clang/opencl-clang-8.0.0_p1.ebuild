# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

CLANG_VERSION=8
MY_PV="${PV//_p/-}"

DESCRIPTION="Thin wrapper library around clang for OpenCL"
HOMEPAGE="https://github.com/intel/opencl-clang"
SRC_URI="https://github.com/intel/opencl-clang/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# depend only on opencl-clang to pull in the right slots of clang and llvm
DEPEND="=dev-util/spirv-llvm-translator-${CLANG_VERSION}*"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default

	cmake-utils_src_prepare

	# we install clang in a separate top-dir, but this build system
	# assumes clang below llvm
	sed -i \
		-e "s|\${LLVM_LIBRARY_DIRS}|/usr/$(get_libdir)|" \
		cl_headers/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_PREBUILT_LLVM=ON
		-DPREFERRED_LLVM_VERSION="${CLANG_VERSION}"
		-DLLVMSPIRV_INCLUDED_IN_LLVM=OFF
		-DSPIRV_TRANSLATOR_DIR="${EPREFIX}/usr"
	)

	cmake-utils_src_configure
}
