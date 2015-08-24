# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="serial graphics adapter bios option rom for x86"
HOMEPAGE="https://code.google.com/p/sgabios/"
SRC_URI="mirror://gentoo/${P}.tar.xz
	https://dev.gentoo.org/~cardoe/distfiles/${P}.tar.xz
	https://dev.gentoo.org/~cardoe/distfiles/${P}-bins.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-build-cc.patch #552280
	epatch_user
}

src_compile() {
	if use amd64 || use x86 ; then
		tc-ld-disable-gold
		tc-export_build_env BUILD_CC
		emake \
			BUILD_CC="${BUILD_CC}" \
			BUILD_CFLAGS="${BUILD_CFLAGS}" \
			BUILD_LDFLAGS="${BUILD_LDFLAGS}" \
			BUILD_CPPFLAGS="${BUILD_CPPFLAGS}" \
			CC="$(tc-getCC)" \
			LD="$(tc-getLD)" \
			AR="$(tc-getAR)" \
			OBJCOPY="$(tc-getOBJCOPY)"
	fi
}

src_install() {
	insinto /usr/share/sgabios

	if use amd64 || use x86 ; then
		doins sgabios.bin
	else
		doins bins/sgabios.bin
	fi
}
