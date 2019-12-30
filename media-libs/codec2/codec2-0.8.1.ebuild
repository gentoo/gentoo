# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="Low bit rate speech codec"
HOMEPAGE="https://freedv.org/"
SRC_URI="https://hobbes1069.fedorapeople.org/freetel/codec2/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ppc ppc64 ~sparc x86"
IUSE="examples"

PATCHES=( "${FILESDIR}/${P}-unused-deps.patch" )

multilib_src_configure() {
	local mycmakeargs=( -DUNITTEST=OFF )
	cmake_src_configure
}

src_install() {
	cmake-multilib_src_install

	if use examples; then
		insinto /usr/share/codec2
		doins -r wav raw
	fi
}
