# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils fdo-mime qmake-utils games

DESCRIPTION="Multimedia interpreter for TADS text adventures"
HOMEPAGE="http://qtads.sourceforge.net"
SRC_URI="mirror://sourceforge/qtads/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[sound]
	media-libs/sdl-mixer[midi,vorbis]
	media-libs/sdl-sound[mp3]
	dev-qt/qtcore:5
	dev-qt/qtgui:5"
RDEPEND=${DEPEND}

src_configure() {
	eqmake5 qtads.pro -after CONFIG-=silent
}

src_install() {
	dogamesbin qtads
	dodoc AUTHORS HTML_TADS_LICENSE NEWS README
	insinto /usr
	doins -r share
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
