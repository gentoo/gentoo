# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/dfarc/dfarc-3.12.ebuild,v 1.2 2015/06/11 07:41:53 mr_bones_ Exp $

EAPI=5
WX_GTK_VER="3.0"
inherit gnome2-utils fdo-mime wxwidgets games

DESCRIPTION="Frontend and .dmod installer for GNU FreeDink"
HOMEPAGE="http://www.freedink.org/"
SRC_URI="mirror://gnu/freedink/${P}.tar.gz"

LICENSE="GPL-3 BZIP2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	app-arch/bzip2
	x11-misc/xdg-utils
	x11-libs/wxGTK:${WX_GTK_VER}"
DEPEND="${RDEPEND}
	nls? ( >=dev-util/intltool-0.31 )"

src_configure() {
	egamesconf \
		$(use_enable nls) \
		--disable-desktopfiles
}

src_install() {
	default
	dodoc TRANSLATIONS.txt
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
