# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Yamaha DX7 modeling DSSI plugin"
HOMEPAGE="http://dssi.sourceforge.net/hexter.html"
SRC_URI="mirror://sourceforge/dssi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk readline"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	readline? ( sys-libs/readline sys-libs/ncurses )
	media-libs/alsa-lib
	>=media-libs/dssi-0.4
	>=media-libs/liblo-0.12"
DEPEND="${RDEPEND}
	media-libs/ladspa-sdk
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_with gtk gtk2) \
		$(use_with readline textui)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README TODO
}
