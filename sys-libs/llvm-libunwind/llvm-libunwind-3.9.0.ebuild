# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
inherit cmake-multilib

MY_P="libunwind-${PV}"
DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
SRC_URI="http://llvm.org/releases/${PV}/${MY_P}.src.tar.xz"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +static-libs"

RDEPEND="!sys-libs/libunwind"
# llvm-config and cmake files needed to get proper flags
# (3.9.0 needed because cmake file install path changed)
DEPEND=">=sys-devel/llvm-3.9.0[${MULTILIB_USEDEP}]"

S="${WORKDIR}/${MY_P}.src"

src_prepare() {
	# add switch for static-libs; accepted upstream
	eapply "${FILESDIR}/libunwind-3.9-cmake-static-lib.patch"
	default
}

multilib_src_configure() {
	local libdir=$(get_libdir)

	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBUNWIND_ENABLE_ASSERTIONS=$(usex debug)
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
	)

	cmake-utils_src_configure
}
