# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/xvattr/xvattr-1.3-r3.ebuild,v 1.1 2015/04/05 23:23:02 dilfridge Exp $

EAPI=5

inherit eutils autotools

DESCRIPTION="X11 XVideo Querying/Setting Tool from Ogle project"
HOMEPAGE="http://www.dtek.chalmers.se/groups/dvd"
SRC_URI="http://www.dtek.chalmers.se/groups/dvd/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gtk"

RDEPEND="x11-libs/libX11
	x11-libs/libXv
	x11-libs/libXext
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	x11-libs/libXt
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gtk.patch
	epatch "${FILESDIR}"/${P}-pod-encoding.patch
	eautoreconf
}

src_configure() {
	econf $(use_with gtk)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
}
