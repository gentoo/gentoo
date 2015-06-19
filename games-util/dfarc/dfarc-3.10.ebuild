# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/dfarc/dfarc-3.10.ebuild,v 1.4 2013/09/14 20:13:45 hasufell Exp $

EAPI=5

WX_GTK_VER="2.8"
inherit gnome2-utils fdo-mime wxwidgets games

DESCRIPTION="Frontend and .dmod installer for GNU FreeDink"
HOMEPAGE="http://www.freedink.org/"
SRC_URI="mirror://gnu/freedink/${P}.tar.gz"

LICENSE="GPL-3 BZIP2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="
	app-arch/bzip2
	x11-misc/xdg-utils
	x11-libs/wxGTK:${WX_GTK_VER}"
DEPEND="${RDEPEND}
	nls? ( >=dev-util/intltool-0.31 )"

src_prepare() {
	sed -i \
		-e 's#^datarootdir =.*$#datarootdir = /usr/share#' \
		share/Makefile.in || die
}

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
