# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils gnome2-utils

DESCRIPTION="Streaming GTK+ Front-End based in Darkice Ice Streamer"
HOMEPAGE="http://darksnow.radiolivre.org"
SRC_URI="http://darksnow.radiolivre.org/pacotes/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

PDEPEND=">=media-sound/darkice-1.2"
RDEPEND=">=x11-libs/gtk+-2.14.0:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc documentation/{CHANGES,CREDITS,README*}
	make_desktop_entry ${PN} "DarkSnow" ${PN}
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
