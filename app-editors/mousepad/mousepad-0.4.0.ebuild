# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit gnome2-utils xfconf

DESCRIPTION="GTK+-based editor for the Xfce Desktop Environment"
HOMEPAGE="https://goodies.xfce.org/projects/applications/start"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug dbus gtk3"

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

pkg_setup() {
	XFCONF=(
		$(xfconf_use_debug)
		$(use_enable dbus)
		$(use_enable gtk3)
		)

	DOCS=( AUTHORS ChangeLog NEWS README TODO )
}

pkg_preinst() {
	xfconf_pkg_preinst
	gnome2_schemas_savelist
}

pkg_postinst() {
	xfconf_pkg_postinst
	gnome2_schemas_update
}
