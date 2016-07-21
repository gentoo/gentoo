# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="Standard kernel module utilities for linux-2.4 and older"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/kernel/modutils/"
SRC_URI="mirror://kernel/linux/utils/kernel/${PN}/v2.4/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="!sys-apps/module-init-tools
	!sys-apps/kmod"

src_prepare() {
	epatch "${FILESDIR}"/${P}-alias.patch
	epatch "${FILESDIR}"/${P}-gcc.patch
	epatch "${FILESDIR}"/${P}-flex.patch
	epatch "${FILESDIR}"/${P}-no-nested-function.patch
}

src_configure() {
	econf \
		--prefix=/ \
		--disable-strip \
		--enable-insmod-static \
		--disable-zlib
}

src_install() {
	einstall prefix="${D}"
	rm -r "${ED}"/usr/share/man/man2 || die
	dodoc CREDITS ChangeLog NEWS README TODO
}
