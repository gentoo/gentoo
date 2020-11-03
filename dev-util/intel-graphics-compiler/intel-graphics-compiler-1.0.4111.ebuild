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
KEYWORDS="amd64"
IUSE="debug"

LLVM_MAX_SLOT=10

COMMON="<=sys-devel/llvm-${LLVM_MAX_SLOT}.9999:=[${MULTILIB_USEDEP}]
	<=dev-libs/opencl-clang-${LLVM_MAX_SLOT}.9999:=[${MULTILIB_USEDEP}]"
DEPEND="${COMMON}"
RDEPEND="${COMMON}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.9-no_Werror.patch
	"${FILESDIR}"/${PN}-1.0.4111-opencl-clang_version.patch
)

S="${WORKDIR}"/${PN}-igc-${PV}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if tc-is-clang && [[ $(clang-major-version) -ge 10 ]] ; then
			die "Building IGC with clang-10 and newer is presently not supported (see Bug #738934). Please use clang-9 or gcc instead."
		fi
	fi
}

multilib_src_configure() {
	# Select the same slot as the best opencl-clang
	local ocl_clang_ver="$(best_version -d dev-libs/opencl-clang:=)"
	einfo "Selecting $ocl_clang_ver"
	local llvm_slot=$(ver_cut 5 $ocl_clang_ver)
	# opencl-clang brings the right slot as dep
	has_version -d sys-devel/llvm:$llvm_slot || die "LLVM slot matching $ocl_clang_ver not found ($llvm_slot)"
	einfo "Selecting LLVM SLOT $llvm_slot: $(best_version -d sys-devel/llvm:$llvm_slot)"

	# Since late March 2020 cmake.eclass does not set -DNDEBUG any more, and the way
	# IGC uses this definition causes problems for some users (see Bug #718824).
	use debug || append-cppflags -DNDEBUG

	local mycmakeargs=(
		-DCCLANG_SONAME_VERSION=${llvm_slot}
		-DCMAKE_LIBRARY_PATH=$(get_llvm_prefix ${llvm_slot})/$(get_libdir)
		-DIGC_OPTION__FORCE_SYSTEM_LLVM=ON
		-DIGC_PREFERRED_LLVM_VERSION=${llvm_slot}
	)
	cmake_src_configure
}
