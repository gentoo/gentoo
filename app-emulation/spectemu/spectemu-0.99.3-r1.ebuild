# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils

DESCRIPTION="48k ZX Spectrum Emulator"
HOMEPAGE="http://kempelen.iit.bme.hu/~mszeredi/spectemu/spectemu.html"
SRC_URI="http://www.inf.bme.hu/~mszeredi/spectemu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="readline svga +X"

REQUIRED_USE="|| ( svga X )"

DEPEND="X? ( >=x11-proto/xf86vidmodeproto-2.2.2
		>=x11-proto/xextproto-7.0.2
		>=x11-proto/xproto-7.0.4
		>=x11-libs/libX11-1.0.0
		>=x11-libs/libXext-1.0.0
		>=x11-libs/libXxf86vm-1.0.0 )
	readline? ( sys-libs/readline )"
RDEPEND="${DEPEND}
	svga? ( media-libs/svgalib )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-automagic.patch
	epatch "${FILESDIR}"/${P}-build.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_with readline) \
		$(use_with svga) \
		$(use_with X x)
}

src_install() {
	emake install_root="${D}" install
}
