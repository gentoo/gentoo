# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="A session daemon for MATE that makes it easy to manage your laptop or desktop"

LICENSE="GPL-2"
SLOT="0"
IUSE="+applet elogind gnome-keyring policykit systemd test"

REQUIRED_USE="?? ( elogind systemd )"

# Interactive testsuite.
RESTRICT="test"

COMMON_DEPEND="
	>=dev-libs/dbus-glib-0.70
	>=dev-libs/glib-2.50:2
	>=media-libs/libcanberra-0.10:0[gtk3]
	>=sys-apps/dbus-1
	>=x11-apps/xrandr-1.3
	>=x11-libs/cairo-1
	>=x11-libs/gdk-pixbuf-2.11:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	>=x11-libs/libnotify-0.7:0
	x11-libs/pango
	applet? ( >=mate-base/mate-panel-1.17.0 )
	gnome-keyring? ( >=gnome-base/libgnome-keyring-3 )
	>=sys-power/upower-0.9.23:="

RDEPEND="${COMMON_DEPEND}
	policykit? ( >=mate-extra/mate-polkit-1.6 )
	systemd? ( sys-apps/systemd )
	!systemd? (
		elogind? ( sys-auth/elogind )
		!elogind? ( >=sys-auth/consolekit-0.9.2 )
	)"

DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	app-text/rarian
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools
	dev-util/glib-utils
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
	x11-base/xorg-proto"

src_configure() {
	mate_src_configure \
		--enable-compile-warnings=minimum \
		$(use_with gnome-keyring keyring) \
		$(use_enable applet applets) \
		$(use_enable test tests)
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS

	dbus-launch Xemake check || die "Test phase failed"
}
