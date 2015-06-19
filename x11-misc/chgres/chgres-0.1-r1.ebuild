# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/chgres/chgres-0.1-r1.ebuild,v 1.4 2011/12/13 23:23:52 ago Exp $

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="A very simple command line utility for changing X resolutions"
HOMEPAGE="http://hpwww.ec-lyon.fr/~vincent/"
SRC_URI="http://hpwww.ec-lyon.fr/~vincent/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXxf86dga
	x11-libs/libXext
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	x11-proto/xf86vidmodeproto
	x11-proto/xf86dgaproto"

src_prepare() {
	epatch "${FILESDIR}"/${P}-{flags,includes}.patch
	tc-export CC
}

src_install() {
	dobin chgres
	dodoc README
}
