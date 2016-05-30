# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GCONF_DEBUG="no"

inherit autotools gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="The MATE System Monitor"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="systemd"

RDEPEND="
	>=dev-cpp/glibmm-2.16:2
	>=dev-cpp/gtkmm-2.22:2.4
	>=dev-libs/dbus-glib-0.70:0
	>=dev-libs/glib-2.36:2
	dev-libs/libsigc++:2
	>=dev-libs/libxml2-2:2
	>=gnome-base/libgtop-2.23.1:2=
	>=gnome-base/librsvg-2.35:2
	>=sys-apps/dbus-0.7:0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.20:2
	>=x11-libs/libwnck-2.5:1
	>=x11-themes/mate-icon-theme-1.10:0
	virtual/libintl:0
	systemd? ( sys-apps/systemd )"

DEPEND="${RDEPEND}
	app-text/yelp-tools:0
	>=dev-util/intltool-0.35:*
	mate-base/mate-common
	sys-devel/gettext:*
	>=sys-devel/autoconf-2.63:*
	virtual/pkgconfig:*"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	# Add support for "smart" CXXFLAGS and C++11 switch
	# see https://github.com/mate-desktop/mate-system-monitor/commit/56594f
	epatch "${FILESDIR}/${P}-cxxflags-cpp11.patch"
	eautoreconf
	default
}
