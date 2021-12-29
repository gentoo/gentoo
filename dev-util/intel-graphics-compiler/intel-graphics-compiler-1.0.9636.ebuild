# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE="Release"
LLVM_MAX_SLOT="13"
MY_PN="igc"
MY_P="${MY_PN}-${PV}"
#PYTHON_COMPAT=( python3_{8..10} )
PYTHON_COMPAT=( python3_10 )

inherit cmake flag-o-matic llvm python-any-r1 git-r3

DESCRIPTION="LLVM-based OpenCL compiler for OpenCL targetting Intel Gen graphics hardware"
HOMEPAGE="https://github.com/intel/intel-graphics-compiler"
SRC_URI="https://github.com/intel/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
EGIT_REPO_URI="https://github.com/KhronosGroup/SPIRV-Tools.git"
EGIT_REPO_URI1="https://github.com/KhronosGroup/SPIRV-Headers.git"
EGIT_REPO_URI2="https://github.com/intel/vc-intrinsics.git"  EGIT_COMMIT2="8ee879314584e6630688b0a3b290d065dcabb383"
# protobuf version 3.19.1 - but it is unnecesary 
#EGIT_REPO_URI3="https://github.com/protocolbuffers/protobuf" EGIT_COMMIT3="7c40b2df1fdf6f414c1c18c789715a9c948a0725"
S="${WORKDIR}/${PN}-${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="
	dev-libs/opencl-clang:${LLVM_MAX_SLOT}=
	sys-devel/llvm:${LLVM_MAX_SLOT}=
"

RDEPEND="${DEPEND}"

BDEPEND="
	${PYTHON_DEPS}
	>=sys-devel/lld-${LLVM_MAX_SLOT}
"

## Fixes compilation 
## https://bugs.gentoo.org/827651
src_unpack() {
	default
	git-r3_fetch ${EGIT_REPO_URI}
	git-r3_checkout ${EGIT_REPO_URI} "${WORKDIR}/SPIRV-Tools"
	git-r3_fetch ${EGIT_REPO_URI1}
	git-r3_checkout ${EGIT_REPO_URI1} "${WORKDIR}/SPIRV-Headers"
	git-r3_fetch ${EGIT_REPO_URI2} ${EGIT_COMMIT2}
	git-r3_checkout ${EGIT_REPO_URI2} "${WORKDIR}/vc-intrinsics"
	#git-r3_fetch ${EGIT_REPO_URI3} ${EGIT_COMMIT3}
	#git-r3_checkout ${EGIT_REPO_URI3} "${WORKDIR}/protobuf"
}

PATCHES=(
	"${FILESDIR}/${PN}-1.0.9-no_Werror.patch"
	"${FILESDIR}/${PN}-1.0.8173-opencl-clang_version.patch"
	"${FILESDIR}/${PN}-1.0.8365-disable-git.patch"
	"${FILESDIR}/${PN}-1.0.8365-cmake-project.patch"
	"${FILESDIR}/${PN}-fix-lld-prebuilt.patch"
	"${FILESDIR}/${PN}-fix-missing-limits.patch"
)

pkg_setup() {
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	# Since late March 2020 cmake.eclass does not set -DNDEBUG any more,
	# and the way IGC uses this definition causes problems for some users.
	# See bug #718824 for more information.
	! use debug && append-cppflags -DNDEBUG

	# Get LLVM version
	local llvm_version="$(best_version -d sys-devel/llvm:${LLVM_MAX_SLOT})"

	local mycmakeargs=(
		# Those options are ensuring, that we are using
		# the system LLVM with the correct slot.
		-DCCLANG_SONAME_VERSION="${LLVM_MAX_SLOT}"
		-DCMAKE_LIBRARY_PATH="$(get_llvm_prefix ${LLVM_MAX_SLOT})/$(get_libdir)"
		-DIGC_OPTION__ARCHITECTURE_TARGET="Linux64"
		-DIGC_OPTION__CLANG_MODE="Prebuilds"
		-DIGC_OPTION__LLD_MODE="Prebuilds"
		-DIGC_OPTION__LLDELF_H_DIR="${EPREFIX}/usr/include/lld/Common"
		-DIGC_OPTION__LLVM_MODE="Prebuilds"
		-DIGC_OPTION__LLVM_PREFERRED_VERSION="${llvm_version##*-}"

		# VectorCompiler needs work, as at the moment upstream
		# only supports building vc-intrinsics in place.
		-DIGC_BUILD__VC_ENABLED="ON"

		# See comments on https://github.com/intel/intel-graphics-compiler/issues/148#issuecomment-916228192
		# There is on place so:
		-DIGC_OPTION__LINK_KHRONOS_SPIRV_TRANSLATOR=ON
		-DIGC_OPTION__USE_KHRONOS_SPIRV_TRANSLATOR_IN_VC=ON
		-DIGC_OPTION__SPIRV_TRANSLATOR_MODE=Prebuilds
		-DVC_INTRINSICS_SRC="${WORKDIR}/vc-intrinsics"
		-DPROTOBUF_SRC_ROOT_FOLDER="${WORKDIR}/protobuf"
		-DSPIRVLLVMTranslator_ROOT="/usr/lib/llvm/13/include/LLVMSPIRVLib/"
		# see https://issueexplorer.com/issue/intel/intel-graphics-compiler/212
		-DBUILD_SHARED_LIBS:BOOL=OFF
		-DINSTALL_GENX_IR=ON
		# This will suspress some CMake warnings,
		# which cannot be fixed at the moment.
		-Wno-dev
	)

	cmake_src_configure
}
