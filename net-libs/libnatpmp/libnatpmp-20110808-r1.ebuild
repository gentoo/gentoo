# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnatpmp/libnatpmp-20110808-r1.ebuild,v 1.11 2015/07/04 02:03:27 blueness Exp $

EAPI=4
inherit eutils toolchain-funcs multilib

DESCRIPTION="An alternative protocol to UPnP IGD specification"
HOMEPAGE="http://miniupnp.free.fr/libnatpmp.html"
SRC_URI="http://miniupnp.free.fr/files/download.php?file=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="sparc"
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}"/respect-FLAGS.patch
	epatch "${FILESDIR}"/respect-libdir.patch
	use static-libs || epatch "${FILESDIR}"/remove-static-lib.patch
	tc-export CC
}

src_install() {
	emake PREFIX="${D}" GENTOO_LIBDIR="$(get_libdir)" install

	dodoc Changelog.txt README
	doman natpmpc.1
}
