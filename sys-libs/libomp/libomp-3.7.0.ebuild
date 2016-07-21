# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}

inherit cmake-utils multilib-minimal

MY_P=openmp-${PV}
DESCRIPTION="OpenMP runtime library for LLVM/clang compiler"
HOMEPAGE="http://openmp.llvm.org"
SRC_URI="http://llvm.org/releases/${PV}/${MY_P}.src.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0/3.7"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}.src"

PATCHES=(
	"${FILESDIR}"/${P}-os_detection.patch
	"${FILESDIR}"/${P}-no_compat_symlinks.patch
	)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if ! test-flag-CXX -std=c++11; then
			eerror "${P} requires C++11-capable C++ compiler. Your current compiler"
			eerror "does not seem to support -std=c++11 option. Please upgrade your compiler"
			eerror "to gcc-4.7 or an equivalent version supporting C++11."
			die "Currently active compiler does not support -std=c++11"
		fi
	fi
}

multilib_src_configure() {
	local libdir="$(get_libdir)"
	local mycmakeargs=( "-DLIBOMP_LIBDIR_SUFFIX=${libdir#lib}" )
	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install
}
