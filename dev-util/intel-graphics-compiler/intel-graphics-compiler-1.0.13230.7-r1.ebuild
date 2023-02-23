# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
LLVM_MAX_SLOT="14"
MY_PN="igc"
MY_P="${MY_PN}-${PV}"
PYTHON_COMPAT=( python3_{9..11} )

inherit cmake flag-o-matic llvm python-any-r1

DESCRIPTION="LLVM-based OpenCL compiler for OpenCL targetting Intel Gen graphics hardware"
HOMEPAGE="https://github.com/intel/intel-graphics-compiler"
SRC_URI="https://github.com/intel/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug vc"

DEPEND="
	dev-libs/opencl-clang:${LLVM_MAX_SLOT}=
	dev-util/spirv-tools
	sys-devel/lld:${LLVM_MAX_SLOT}=
	sys-devel/llvm:${LLVM_MAX_SLOT}=
	vc? (
		>=dev-libs/intel-vc-intrinsics-0.11.0
		dev-util/spirv-llvm-translator:${LLVM_MAX_SLOT}=
	)
"

RDEPEND="${DEPEND}"

BDEPEND="
	=sys-devel/lld-${LLVM_MAX_SLOT}*
	${PYTHON_DEPS}
"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.9-no_Werror.patch"
	"${FILESDIR}/${PN}-1.0.8173-opencl-clang_version.patch"
	"${FILESDIR}/${PN}-1.0.8365-disable-git.patch"
	"${FILESDIR}/${PN}-1.0.11485-include-opencl-c.patch"
	"${FILESDIR}/${PN}-1.0.13230.7-spirv-tools.patch"
)

pkg_setup() {
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	# Get LLVM version
	local llvm_version="$(best_version -d sys-devel/llvm:${LLVM_MAX_SLOT})"
	local llvm_version="${llvm_version%%-r*}"

	# See https://github.com/intel/intel-graphics-compiler/issues/212
	append-ldflags -Wl,-z,undefs

	# See bug #893370 and https://github.com/intel/intel-graphics-compiler/issues/282
	append-flags -U_GLIBCXX_ASSERTIONS

	# See https://bugs.gentoo.org/718824
	! use debug && append-cppflags -DNDEBUG

	local mycmakeargs=(
		-DCCLANG_INCLUDE_PREBUILDS_DIR="/usr/lib/clang/${llvm_version##*-}/include"
		-DCCLANG_SONAME_VERSION="${LLVM_MAX_SLOT}"
		-DCMAKE_LIBRARY_PATH="$(get_llvm_prefix ${LLVM_MAX_SLOT})/$(get_libdir)"
		-DIGC_BUILD__VC_ENABLED="$(usex vc)"
		-DIGC_OPTION__ARCHITECTURE_TARGET="Linux64"
		-DIGC_OPTION__CLANG_MODE="Prebuilds"
		-DIGC_OPTION__LINK_KHRONOS_SPIRV_TRANSLATOR="ON"
		-DIGC_OPTION__LLD_MODE="Prebuilds"
		-DIGC_OPTION__LLDELF_H_DIR="${EPREFIX}/usr/include/lld/Common"
		-DIGC_OPTION__LLVM_MODE="Prebuilds"
		-DIGC_OPTION__LLVM_PREFERRED_VERSION="${llvm_version##*-}"
		-DIGC_OPTION__SPIRV_TOOLS_MODE="Prebuilds"
		-DIGC_OPTION__SPIRV_TRANSLATOR_MODE="Prebuilds"
		-DIGC_OPTION__USE_PREINSTALLED_SPRIV_HEADERS="ON"
		$(usex vc '-DIGC_OPTION__VC_INTRINSICS_MODE=Prebuilds' '')
		-DINSTALL_GENX_IR="ON"
		-DSPIRVLLVMTranslator_INCLUDE_DIR="${EPREFIX}/usr/lib/llvm/${LLVM_MAX_SLOT}/include/LLVMSPIRVLib"
		-Wno-dev
	)

	cmake_src_configure
}
