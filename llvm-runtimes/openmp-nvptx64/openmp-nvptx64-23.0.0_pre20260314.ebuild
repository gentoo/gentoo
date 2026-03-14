# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake flag-o-matic llvm.org

DESCRIPTION="OpenMP target library for nvptx64 devices"
HOMEPAGE="https://openmp.llvm.org"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0/${LLVM_SOABI}"

RDEPEND="
	!<llvm-runtimes/offload-22[llvm_targets_NVPTX(-)]
"
BDEPEND="
	~llvm-core/clang-${PV}:${LLVM_MAJOR}[llvm_targets_NVPTX]
	llvm-core/lld:${LLVM_MAJOR}[llvm_targets_NVPTX]
"

LLVM_COMPONENTS=(
	runtimes openmp cmake llvm/{cmake,utils/llvm-lit} libc/shared
	offload/include
)
llvm.org_set_globals

src_configure() {
	local -x CC=${CHOST}-clang-${LLVM_MAJOR}
	local -x CXX=${CHOST}-clang++-${LLVM_MAJOR}
	local triple=nvptx64-nvidia-cuda
	filter-flags '-m*'
	strip-unsupported-flags

	local mycmakeargs=(
		-DLLVM_DEFAULT_TARGET_TRIPLE=${triple}
		-DLLVM_ENABLE_RUNTIMES=openmp
		-DOPENMP_INSTALL_LIBDIR="$(get_libdir)/${triple}"
	)
	cmake_src_configure
}
