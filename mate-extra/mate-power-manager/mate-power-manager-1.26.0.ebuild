# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="A session daemon for MATE that makes it easy to manage your laptop or desktop"

LICENSE="FDL-1.1+ GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+applet +elogind libsecret policykit systemd test"

REQUIRED_USE="^^ ( elogind systemd )"

# Interactive testsuite.
RESTRICT="test"

COMMON_DEPEND="
	>=dev-libs/dbus-glib-0.70
	>=dev-libs/glib-2.50:2
	>=media-libs/libcanberra-0.10:0[gtk3]
	>=sys-apps/dbus-1
	>=sys-power/upower-0.99.8:=
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
	libsecret? ( >=app-crypt/libsecret-0.11 )
"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
	policykit? ( >=mate-extra/mate-polkit-1.6 )
	systemd? ( sys-apps/systemd )
	elogind? ( sys-auth/elogind )
"

BDEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	app-text/rarian
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools
	dev-libs/libxml2
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	x11-base/xorg-proto
"

src_configure() {
	mate_src_configure \
		--enable-compile-warnings=minimum \
		$(use_with libsecret) \
		$(use_enable applet applets) \
		$(use_enable test tests)
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS

	dbus-launch Xemake check || die "Test phase failed"
}
