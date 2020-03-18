# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils xdg-utils

DESCRIPTION="GTK+-based editor for the Xfce Desktop Environment"
HOMEPAGE="https://git.xfce.org/apps/mousepad/about/"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dbus +gtk3"
# D-Bus code fails to build against GTK+2
# https://bugzilla.xfce.org/show_bug.cgi?id=15755
REQUIRED_USE="dbus? ( gtk3 )"

RDEPEND=">=dev-libs/glib-2.42:2=
	>=xfce-base/xfconf-4.12:=
	!gtk3? ( >=x11-libs/gtk+-2.24:2=
		x11-libs/gtksourceview:2.0= )
	gtk3? ( >=x11-libs/gtk+-3.20:3=
		x11-libs/gtksourceview:3.0= )"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	dbus? ( dev-util/gdbus-codegen )"

src_configure() {
	local myconf=(
		$(use_enable dbus)
		$(use_enable gtk3)
		)

	econf "${myconf[@]}"
}

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
