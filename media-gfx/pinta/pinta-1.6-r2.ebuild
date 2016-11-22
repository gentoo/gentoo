# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit fdo-mime mono-env gnome2-utils

DESCRIPTION="Simple Painting for Gtk"
HOMEPAGE="http://pinta-project.com"
SRC_URI="https://github.com/PintaProject/Pinta/releases/download/${PV}/${P}.tar.gz"

LICENSE="MIT CC-BY-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND="dev-lang/mono
	dev-dotnet/mono-addins[gtk]"
RDEPEND="${COMMON_DEPEND}
	x11-libs/cairo[X]
	x11-libs/gdk-pixbuf[X,jpeg,tiff]
	x11-themes/gnome-icon-theme"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	epatch "${FILESDIR}/${P}-mono-4.patch"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
