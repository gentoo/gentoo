# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/qtads/qtads-2.1.6.ebuild,v 1.6 2015/02/10 10:16:04 ago Exp $

EAPI=5
inherit eutils gnome2-utils fdo-mime qt4-r2 games

DESCRIPTION="Multimedia interpreter for TADS text adventures"
HOMEPAGE="http://qtads.sourceforge.net"
SRC_URI="mirror://sourceforge/qtads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[sound]
	media-libs/sdl-mixer[midi,vorbis]
	media-libs/sdl-sound[mp3]
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4 qtads.pro -after CONFIG-=silent
}

src_install() {
	dogamesbin qtads
	doman qtads.6
	dodoc AUTHORS HTML_TADS_LICENSE NEWS README
	newicon -s 256 qtads_256x256.png ${PN}.png
	insinto /usr/share/icons
	doins -r icons/hicolor
	insinto /usr/share/mime/packages
	doins icons/qtads.xml
	make_desktop_entry qtads QTads qtads Game "GenericName=TADS Multimedia Interpreter\nMimeType=application/x-tads;application/x-t3vm-image;"
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
