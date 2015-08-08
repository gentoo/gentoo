# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit gnome2-utils

DESCRIPTION="Image viewer/manager with optional support for MPEG movies"
HOMEPAGE="http://pornview.sourceforge.net"
SRC_URI="http://dev.gentoo.org/~hasufell/distfiles/${P}.tar.xz
	mirror://github/gentoo/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 -hppa ppc x86"
IUSE="exif nls"

RDEPEND="
	dev-libs/glib:2
	media-libs/libpng:0
	virtual/jpeg
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXinerama
	exif? ( media-gfx/exiv2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_configure() {
	econf \
		$(use_enable exif) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" desktopdir="/usr/share/applications" \
		install || die "emake install failed."
	dodoc AUTHORS NEWS README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
