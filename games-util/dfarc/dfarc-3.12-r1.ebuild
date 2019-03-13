# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0"
inherit eutils gnome2-utils wxwidgets xdg

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
	x11-libs/wxGTK:${WX_GTK_VER}[X]
"
DEPEND="${RDEPEND}
	nls? ( >=dev-util/intltool-0.31 )
"

PATCHES=( "${FILESDIR}"/${P}-nowindres.patch )

src_configure() {
	econf \
		$(use_enable nls) \
		--disable-desktopfiles
}

src_install() {
	default
	dodoc TRANSLATIONS.txt
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
