# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
LLVM_MAX_SLOT="13"
MY_PN="igc"
MY_P="${MY_PN}-${PV}"
PYTHON_COMPAT=( python3_{8..10} )

inherit cmake flag-o-matic llvm python-any-r1

DESCRIPTION="LLVM-based OpenCL compiler for OpenCL targetting Intel Gen graphics hardware"
HOMEPAGE="https://github.com/intel/intel-graphics-compiler"
SRC_URI="https://github.com/intel/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="
	dev-libs/opencl-clang:${LLVM_MAX_SLOT}=
	dev-util/spirv-tools
	sys-devel/llvm:${LLVM_MAX_SLOT}=
"

RDEPEND="${DEPEND}"

BDEPEND="
	${PYTHON_DEPS}
	>=sys-devel/lld-${LLVM_MAX_SLOT}
"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.9-no_Werror.patch"
	"${FILESDIR}/${PN}-1.0.8173-opencl-clang_version.patch"
	"${FILESDIR}/${PN}-1.0.8365-disable-git.patch"
	"${FILESDIR}/${PN}-1.0.10713-allow-external-spirv-tools-fix-static.patch"
	"${FILESDIR}/${PN}-1.0.10713-allow-external-spirv-tools-last-fix.patch"
)

pkg_setup() {
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	# Get LLVM version
	local llvm_version="$(best_version -d sys-devel/llvm:${LLVM_MAX_SLOT})"

	# See https://github.com/intel/intel-graphics-compiler/issues/212
	append-ldflags -Wl,-z,undefs

	# See https://bugs.gentoo.org/718824
	! use debug && append-cppflags -DNDEBUG

	local mycmakeargs=(
		-DCCLANG_SONAME_VERSION="${LLVM_MAX_SLOT}"
		-DCMAKE_LIBRARY_PATH="$(get_llvm_prefix ${LLVM_MAX_SLOT})/$(get_libdir)"
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
		-DINSTALL_GENX_IR="ON"
		-DSPIRVLLVMTranslator_INCLUDE_DIR="${EPREFIX}/usr/lib/llvm/${LLVM_MAX_SLOT}/include/LLVMSPIRVLib"

		# VectorCompiler needs work, as at the moment upstream
		# only supports building vc-intrinsics in place.
		-DIGC_BUILD__VC_ENABLED="OFF"
		# -DIGC_OPTION__VC_INTRINSICS_MODE="Prebuilds"

		# This will suspress some CMake warnings,
		# which cannot be fixed at the moment.
		-Wno-dev
	)

	cmake_src_configure
}
