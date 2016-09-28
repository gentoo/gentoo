# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}

inherit cmake-multilib git-r3

DESCRIPTION="OpenMP runtime library for LLVM/clang compiler"
HOMEPAGE="http://openmp.llvm.org"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/openmp.git
	https://github.com/llvm-mirror/openmp.git"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl"

multilib_src_configure() {
	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DLIBOMP_LIBDIR_SUFFIX="${libdir#lib}"
		# do not install libgomp.so & libiomp5.so aliases
		-DLIBOMP_INSTALL_ALIASES=OFF
		# disable unnecessary hack copying stuff back to srcdir
		-DLIBOMP_COPY_EXPORTS=OFF
	)
	cmake-utils_src_configure
}
