# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="ACTIVYLIRCD lirc daemon for activy remote control"
HOMEPAGE="http://www.htpc-forum.de/"
SRC_URI="http://www.htpc-forum.de/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libXtst"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-linking.patch" # Bug #277656
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dosbin activylircd
	dobin key2xd eventmapper key2lircd key2xd
	dodoc key2x.conf README
}
