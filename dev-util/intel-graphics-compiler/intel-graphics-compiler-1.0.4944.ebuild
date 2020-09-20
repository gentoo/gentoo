# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake

inherit cmake-multilib flag-o-matic llvm

DESCRIPTION="LLVM-based OpenCL compiler targetting Intel Gen graphics hardware"
HOMEPAGE="https://github.com/intel/intel-graphics-compiler"
SRC_URI="https://github.com/intel/${PN}/archive/igc-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

LLVM_MAX_SLOT=10

# Yes, the last dependency does effectively force the use of llvm-10
# - there are currently no SLOT=9 ebuilds of opencl-clang with mem2reg
# support. Of course with there being no SLOT=9 ebuilds of vc-intrinsics
# (which we'll need soon as well) at all either we are limited to llvm-10 anyway.
COMMON="<=sys-devel/llvm-${LLVM_MAX_SLOT}.9999:=[${MULTILIB_USEDEP}]
	<=dev-libs/opencl-clang-${LLVM_MAX_SLOT}.9999:=[${MULTILIB_USEDEP}]
	>=dev-libs/opencl-clang-10.0.0.2:=[${MULTILIB_USEDEP}]"
DEPEND="${COMMON}"
RDEPEND="${COMMON}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.9-no_Werror.patch
	"${FILESDIR}"/${PN}-1.0.4111-opencl-clang_version.patch
)
#	"${FILESDIR}"/${PN}-1.0.4427-noVC_TranslateBuild_retval.patch

S="${WORKDIR}"/${PN}-igc-${PV}

find_best_llvm_slot() {
	local candidate_slot

	# Select the same slot as the best opencl-clang
	local ocl_clang_ver="$(best_version -d dev-libs/opencl-clang:=)"
	einfo "Selecting ${ocl_clang_ver}"
	candidate_slot=$(ver_cut 5 ${ocl_clang_ver})

	# Sanity check - opencl-clang brings the right LLVM slot as its
	# dependency so if this is missing, something is very wrong.
	has_version -d sys-devel/llvm:${candidate_slot} || die "LLVM slot matching ${ocl_clang_ver} not found (${candidate_slot})"

	echo ${candidate_slot}
}

multilib_src_configure() {
	local llvm_slot=$(find_best_llvm_slot)
	einfo "Selecting LLVM slot ${llvm_slot}: $(best_version -d sys-devel/llvm:${llvm_slot})"
	local llvm_prefix=$(get_llvm_prefix ${llvm_slot})

	# Since late March 2020 cmake.eclass does not set -DNDEBUG any more, and the way
	# IGC uses this definition causes problems for some users (see Bug #718824).
	use debug || append-cppflags -DNDEBUG

	# VectorCompiler needs work, at the moment upstream only supports building vc-intrinsics in place.
	local mycmakeargs=(
		-DCCLANG_SONAME_VERSION=${llvm_slot}
		-DCMAKE_LIBRARY_PATH="${llvm_prefix}"/$(get_libdir)
		-DIGC_OPTION__FORCE_SYSTEM_LLVM=ON
		-DIGC_PREFERRED_LLVM_VERSION=${llvm_slot}
		-DIGC_BUILD__VC_ENABLED=no
	)
	cmake_src_configure
}
