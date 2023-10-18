# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"

inherit cmake docs llvm

LLVM_MAX_SLOT=17

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/hipamd"
SRC_URI="https://github.com/ROCm-Developer-Tools/clr/archive/refs/tags/rocm-${PV}.tar.gz -> rocm-clr-${PV}.tar.gz
	https://github.com/ROCm-Developer-Tools/HIP/archive/refs/tags/rocm-${PV}.tar.gz -> hip-${PV}.tar.gz"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

IUSE="debug"

DEPEND="
	dev-util/hipcc
	>=dev-util/rocminfo-5
	sys-devel/clang:${LLVM_MAX_SLOT}
	dev-libs/rocm-comgr:${SLOT}
	x11-base/xorg-proto
	virtual/opengl
"
RDEPEND="${DEPEND}
	dev-perl/URI-Encode
	sys-devel/clang-runtime:=
	>=dev-libs/roct-thunk-interface-5"

PATCHES=(
	"${FILESDIR}/${PN}-5.7.0-install.patch"
	"${FILESDIR}/${PN}-5.7.1-fix-unaligned-access.patch"
	"${FILESDIR}/${PN}-5.7.1-exec-stack.patch"
	"${FILESDIR}/${PN}-5.7.1-disable-stack-protector.patch"
	"${FILESDIR}/${PN}-5.7.1-no_asan_doc.patch"
)

S="${WORKDIR}/clr-rocm-${PV}/"

src_configure() {
	use debug && CMAKE_BUILD_TYPE="Debug"

	# TODO: Currently a GENTOO configuration is build,
	# this is also used in the cmake configuration files
	# which will be installed to find HIP;
	# Other ROCm packages expect a "RELEASE" configuration,
	# see "hipBLAS"
	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH="$(get_llvm_prefix "${LLVM_MAX_SLOT}")"
		-DCMAKE_BUILD_TYPE=${buildtype}
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_HIPIFY_CLANG=OFF
		-DHIP_PLATFORM=amd
		-DHIP_COMMON_DIR="${WORKDIR}/HIP-rocm-${PV}"
		-DROCM_PATH="${EPREFIX}/usr"
		-DUSE_PROF_API=0
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCLR_BUILD_HIP=ON
		-DHIPCC_BIN_DIR="${EPREFIX}/usr/bin"
		-DOpenGL_GL_PREFERENCE="GLVND"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install

	rm "${ED}/usr/include/hip/hcc_detail" || die

	# files already installed by hipcc, which is a build dep
	rm "${ED}/usr/bin/hipconfig.pl" || die
	rm "${ED}/usr/bin/hipcc.pl" || die
	rm "${ED}/usr/bin/hipcc" || die
	rm "${ED}/usr/bin/hipconfig" || die
	rm "${ED}/usr/bin/hipvars.pm" || die
}
