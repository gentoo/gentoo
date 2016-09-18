# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}

inherit cmake-multilib

MY_P=openmp-${PV}
DESCRIPTION="OpenMP runtime library for LLVM/clang compiler"
HOMEPAGE="http://openmp.llvm.org"
SRC_URI="http://llvm.org/releases/${PV}/${MY_P}.src.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0/3.9"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"

S="${WORKDIR}/${MY_P}.src"

PATCHES=(
	# backport of https://reviews.llvm.org/D24563
	"${FILESDIR}"/${PN}-3.9.0-optional-aliases.patch
)

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
