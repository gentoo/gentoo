# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"

MY_P="libunwind-${PV}"
SRC_URI="http://llvm.org/releases/${PV}/${MY_P}.src.tar.xz"
S="${WORKDIR}/${MY_P}.src"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+static-libs"

DEPEND=""
RDEPEND="!sys-libs/libunwind"

src_prepare() {
	default
	eapply "${FILESDIR}/libunwind-3.8-cmake.patch"
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_CONFIG=OFF
		-DLIBUNWIND_BUILT_STANDALONE=ON
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
