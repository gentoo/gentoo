# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils fdo-mime gnome2-utils

DESCRIPTION="GUI for gnuchess and for internet chess servers"
HOMEPAGE="https://www.gnu.org/software/xboard/"
SRC_URI="mirror://gnu/xboard/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
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

PATCHES=(
	"${FILESDIR}"/${P}-gettext.patch
	"${FILESDIR}"/${P}-gnuchess-default.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-update-mimedb \
		--datadir=/usr/share \
		$(use_enable nls) \
		$(use_enable zippy) \
		--disable-update-mimedb \
		$(use_with gtk) \
		$(use_with Xaw3d) \
		$(usex gtk "--without-Xaw" "$(use_with !Xaw3d Xaw)") \
		--with-gamedatadir="/usr/share/games/${PN}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS COPYRIGHT ChangeLog FAQ.html NEWS README TODO ics-parsing.txt
	use zippy && dodoc zippy.README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
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
