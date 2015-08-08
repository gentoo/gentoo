# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

IUSE=""
S=${WORKDIR}/wmwave
KEYWORDS="ppc x86"
DESCRIPTION="a dockapp that displays quality, link, level and noise of an iee802.11 (wavelan) connection"
SRC_URI="mirror://sourceforge/wmwave/${PN}-0-4.tgz"
HOMEPAGE="http://wmwave.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_prepare() {
	#Honour Gentoo LDFLAGS. Closes bug #337845.
	sed -e "s/\$(FLAGS) -o wmwave/\$(LDFLAGS) -o wmwave/" -i Makefile
}

src_compile() {
	emake FLAGS="${CFLAGS}" || die "Compilation failed"
}

src_install () {
	dobin wmwave
	doman wmwave.1
	dodoc README
}
