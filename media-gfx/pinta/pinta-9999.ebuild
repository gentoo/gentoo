# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit fdo-mime mono-env gnome2-utils autotools git-r3

DESCRIPTION="Simple Painting for Gtk"
HOMEPAGE="https://pinta-project.com"
SRC_URI=""
EGIT_REPO_URI="https://github.com/PintaProject/Pinta.git"

LICENSE="MIT CC-BY-3.0"
SLOT="0"
KEYWORDS=""

COMMON_DEPEND="dev-lang/mono
	dev-dotnet/mono-addins[gtk]"
RDEPEND="${COMMON_DEPEND}
	x11-libs/cairo[X]
	x11-libs/gdk-pixbuf[X,jpeg,tiff]
	x11-themes/adwaita-icon-theme"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	eautoreconf
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
