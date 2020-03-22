# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="The MATE System Monitor"

LICENSE="FDL-1.1+ GPL-2+ LGPL-2+"
SLOT="0"
IUSE="elogind systemd"

REQUIRED_USE="?? ( elogind systemd )"

COMMON_DEPEND="
	>=dev-cpp/glibmm-2.26:2
	>=dev-cpp/gtkmm-3.8:3.0
	>=dev-libs/glib-2.50:2
	dev-libs/libsigc++:2
	>=dev-libs/libxml2-2:2
	>=gnome-base/libgtop-2.23.1:2=
	>=gnome-base/librsvg-2.35:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/libwnck-3.0:3
	virtual/libintl
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )"

RDEPEND="${COMMON_DEPEND}
	>=sys-auth/polkit-0.97:0"

DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	>=sys-devel/autoconf-2.63:*
	virtual/pkgconfig:*"

src_configure() {
	local myconf=()

	if use elogind || use systemd; then
		myconf+=( --enable-systemd )
		if use elogind; then
			myconf+=(
				SYSTEMD_CFLAGS=`pkg-config --cflags "libelogind" 2>/dev/null`
				SYSTEMD_LIBS=`pkg-config --libs "libelogind" 2>/dev/null`
			)
		fi
	else
		myconf+=( --disable-systemd )
	fi

	mate_src_configure "${myconf[@]}"
}
