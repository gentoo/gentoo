# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="The Gnome System Monitor"
HOMEPAGE="https://help.gnome.org/users/gnome-system-monitor/"

LICENSE="GPL-2"
SLOT="0"
IUSE="systemd X"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"

RDEPEND="
	>=dev-libs/glib-2.37.3:2
	>=gnome-base/libgtop-2.28.2:2=
	>=x11-libs/gtk+-3.22:3[X(+)]
	>=dev-cpp/gtkmm-3.3.18:3.0
	>=dev-cpp/glibmm-2.46:2
	>=dev-libs/libxml2-2.0:2
	>=gnome-base/librsvg-2.35:2
	systemd? ( >=sys-apps/systemd-44:0= )
	X? ( >=x11-libs/libwnck-2.91.0:3 )
"
# eautoreconf requires gnome-base/gnome-common
DEPEND="${RDEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.41.0
	virtual/pkgconfig
"

src_configure() {
	# XXX: appdata is deprecated by appstream-glib, upstream must upgrade
	gnome2_src_configure \
		$(use_enable systemd) \
		$(use_enable X broken-wnck) \
		APPDATA_VALIDATE="$(type -P true)"
}
