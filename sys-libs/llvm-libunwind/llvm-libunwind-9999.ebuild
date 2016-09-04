# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
inherit cmake-multilib git-r3

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/libunwind.git
	https://github.com/llvm-mirror/libunwind.git"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS=""
IUSE="debug +static-libs"

RDEPEND="!sys-libs/libunwind"
# llvm-config and cmake files needed to get proper flags
# (3.9.0 needed because cmake file install path changed)
DEPEND=">=sys-devel/llvm-3.9.0"

multilib_src_configure() {
	local libdir=$(get_libdir)

	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBUNWIND_ENABLE_ASSERTIONS=$(usex debug)
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
	)

	cmake-utils_src_configure
}
