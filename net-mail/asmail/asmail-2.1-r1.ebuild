# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs eutils

DESCRIPTION="a small mail monitor similar to xbiff"
HOMEPAGE="http://www.tigr.net"
SRC_URI="http://www.tigr.net/afterstep/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="jpeg libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libICE
	x11-libs/libSM
	jpeg? ( virtual/jpeg:= )"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
	sed -i -e "/LIB/s/-lssl/-lssl -lcrypto/g" \
		configure
}

src_configure() {
	tc-export CC
	econf $(use_enable jpeg)
}

src_install() {
	dobin ${PN}

	newman ${PN}.man ${PN}.1
	newman ${PN}rc.man ${PN}rc.5

	insinto /usr/share/${PN}/pixmaps
	doins pixmaps/cloud-e/*.xpm

	insinto /usr/share/${PN}
	doins -r sounds

	dodoc ${PN}rc.s* CHANGES *.txt README* TODO
}
