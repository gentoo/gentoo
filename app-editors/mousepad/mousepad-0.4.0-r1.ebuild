# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils xdg-utils

DESCRIPTION="GTK+-based editor for the Xfce Desktop Environment"
HOMEPAGE="https://goodies.xfce.org/projects/applications/start"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus gtk3"

RDEPEND=">=dev-libs/glib-2.30:2=
	dbus? ( >=dev-libs/dbus-glib-0.100:0= )
	!gtk3? ( >=x11-libs/gtk+-2.24:2=
		x11-libs/gtksourceview:2.0= )
	gtk3? ( x11-libs/gtk+:3=
		x11-libs/gtksourceview:3.0= )"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	local myconf=(
		$(use_enable dbus)
		$(use_enable gtk3)
		)

	econf "${myconf[@]}"
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
	xdg_desktop_database_update
}
