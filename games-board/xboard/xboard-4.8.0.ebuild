# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/xboard/xboard-4.8.0.ebuild,v 1.3 2015/01/26 09:52:15 ago Exp $

EAPI=5
inherit autotools eutils fdo-mime gnome2-utils games

DESCRIPTION="GUI for gnuchess and for internet chess servers"
HOMEPAGE="http://www.gnu.org/software/xboard/"
SRC_URI="mirror://gnu/xboard/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="Xaw3d +default-font gtk nls zippy"
RESTRICT="test" #124112

RDEPEND="
	dev-libs/glib:2
	gnome-base/librsvg:2
	virtual/libintl
	x11-libs/cairo[X]
	x11-libs/libXpm
	default-font? (
		media-fonts/font-adobe-100dpi[nls?]
		media-fonts/font-misc-misc[nls?]
	)
	!gtk? (
		x11-libs/libX11
		x11-libs/libXt
		x11-libs/libXmu
		Xaw3d? ( x11-libs/libXaw3d )
		!Xaw3d? ( x11-libs/libXaw )
	)
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	x11-proto/xproto
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gettext.patch \
		"${FILESDIR}"/${P}-gnuchess-default.patch
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-update-mimedb \
		--datadir=/usr/share \
		$(use_enable nls) \
		$(use_enable zippy) \
		--disable-update-mimedb \
		$(use_with gtk) \
		$(use_with Xaw3d) \
		$(usex gtk "--without-Xaw" "$(use_with !Xaw3d Xaw)") \
		--with-gamedatadir="${GAMES_DATADIR}"/${PN}
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS COPYRIGHT ChangeLog NEWS README TODO ics-parsing.txt
	use zippy && dodoc zippy.README
	dohtml FAQ.html
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	elog "No chess engines are emerged by default! If you want a chess engine"
	elog "to play with, you can emerge gnuchess or crafty."
	elog "Read xboard FAQ for information."
	if ! use default-font ; then
		ewarn "Read the xboard(6) man page for specifying the font for xboard to use."
	fi
}

pkg_postrm() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
