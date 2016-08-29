# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="The MATE System Monitor"
LICENSE="GPL-2"
SLOT="0"

IUSE="gtk3 systemd"

RDEPEND="
	>=dev-cpp/glibmm-2.26:2
	>=dev-libs/dbus-glib-0.70:0
	>=dev-libs/glib-2.36:2
	dev-libs/libsigc++:2
	>=dev-libs/libxml2-2:2
	>=gnome-base/libgtop-2.23.1:2=
	>=gnome-base/librsvg-2.35:2
	>=sys-apps/dbus-0.7:0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	virtual/libintl:0
	!gtk3? (
		>=dev-cpp/gtkmm-2.22:2.4
		>=x11-libs/gtk+-2.20:2
		>=x11-libs/libwnck-2.5:1
	)
	gtk3? (
		>=dev-cpp/gtkmm-3.0:3.0
		>=x11-libs/gtk+-3.0:3
		>=x11-libs/libwnck-2.91:3
	)
	systemd? ( sys-apps/systemd )"

DEPEND="${RDEPEND}
	app-text/yelp-tools:0
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	>=sys-devel/autoconf-2.63:*
	virtual/pkgconfig:*"

src_configure() {
	mate_src_configure \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_enable systemd)
}
