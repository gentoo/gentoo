# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils xdg-utils

DESCRIPTION="GTK+-based editor for the Xfce Desktop Environment"
HOMEPAGE="https://git.xfce.org/apps/mousepad/about/"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND=">=dev-libs/glib-2.45.8:2=
	>=xfce-base/xfconf-4.12:=
	>=x11-libs/gtk+-3.20:3=
	x11-libs/gtksourceview:3.0="
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_postinst() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}
