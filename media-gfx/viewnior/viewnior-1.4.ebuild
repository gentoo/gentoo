# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/viewnior/viewnior-1.4.ebuild,v 1.3 2015/06/26 08:47:47 ago Exp $

EAPI="5"
inherit fdo-mime gnome2-utils autotools

DESCRIPTION="Fast and simple image viewer"
HOMEPAGE="http://xsisqox.github.com/Viewnior/index.html"
SRC_URI="https://www.dropbox.com/s/zytq0suabesv933/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/glib:2
	media-gfx/exiv2
	>=x11-libs/gtk+-2.20:2
	x11-misc/shared-mime-info"
RDEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog* NEWS README TODO"

src_prepare() {
	# fix for bug #454230
	sed -r -i "s:(PKG_CHECK_MODULES):AC_CHECK_LIB([m],[cos])\n\n\1:" configure.ac

	eautoreconf
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
