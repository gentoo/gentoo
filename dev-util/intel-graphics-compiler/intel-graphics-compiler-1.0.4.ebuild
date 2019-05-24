# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib llvm toolchain-funcs

DESCRIPTION="LLVM-based OpenCL compiler targetting Intel Gen graphics hardware"
HOMEPAGE="https://github.com/intel/intel-graphics-compiler"
SRC_URI="https://github.com/intel/${PN}/archive/igc-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

COMMON="sys-devel/llvm:8=[${MULTILIB_USEDEP}]
	dev-libs/opencl-clang:8=[${MULTILIB_USEDEP}]"
DEPEND="${COMMON}"
RDEPEND="${COMMON}"

LLVM_MAX_SLOT=8

S="${WORKDIR}"/${PN}-igc-${PV}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		if tc-is-gcc && [[ $(gcc-major-version) -ge 9 ]]; then
			# Bug #685790
			eerror "Compilation with gcc-9+ is not supported yet. Switch to an older version and try again."
			die "Tried to use too new gcc."
		fi
	fi
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCCLANG_BUILD_INTREE_LLVM=OFF
		-DCMAKE_LIBRARY_PATH=$(get_llvm_prefix)/$(get_libdir)
		-DIGC_OPTION__FORCE_SYSTEM_LLVM=ON
		-DIGC_PREFERRED_LLVM_VERSION=8
		# Until a new official release of opencl-clang
		-DCOMMON_CLANG_LIBRARY_NAME=common_clang
	)
	cmake-utils_src_configure
}
