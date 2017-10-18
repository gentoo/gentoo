# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="The MATE System Monitor"
LICENSE="GPL-2"
SLOT="0"

IUSE="systemd"

COMMON_DEPEND="
	>=dev-cpp/glibmm-2.26:2
	>=dev-cpp/gtkmm-3.8:3.0
	>=dev-libs/glib-2.36:2
	dev-libs/libsigc++:2
	>=dev-libs/libxml2-2:2
	>=gnome-base/libgtop-2.23.1:2=
	>=gnome-base/librsvg-2.35:2
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.14:3
	>=x11-libs/libwnck-3.0:3
	virtual/libintl:0
	systemd? ( sys-apps/systemd )"

RDEPEND="${COMMON_DEPEND}
	>=sys-auth/polkit-0.97:0"

DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools:0
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	>=sys-devel/autoconf-2.63:*
	virtual/pkgconfig:*"

src_configure() {
	mate_src_configure \
		$(use_enable systemd)
}

pkg_postinst() {
	mate_pkg_postinst

	einfo "${PN} may run commands with escalated privileges using"
	einfo "x11-libs/gksu."
}
