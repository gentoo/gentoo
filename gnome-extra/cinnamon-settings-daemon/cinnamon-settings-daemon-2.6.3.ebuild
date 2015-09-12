# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 virtualx

DESCRIPTION="Cinnamon's settings daemon"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cinnamon-settings-daemon/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+colord cups input_devices_wacom smartcard systemd"

# udev is non-optional since lots of plugins, not just gudev, pull it in
RDEPEND="
	>=dev-libs/glib-2.38:2
	>=gnome-base/libgnomekbd-3.6
	>=gnome-base/librsvg-2.36.2
	>=gnome-extra/cinnamon-desktop-2.6.3:0=
	media-libs/fontconfig
	>=media-libs/lcms-2.2:2
	media-libs/libcanberra:0=[gtk3]
	>=media-sound/pulseaudio-0.9.16:0=
	sys-apps/dbus
	>=sys-auth/polkit-0.97
	|| ( >=sys-power/upower-0.9.11:= sys-power/upower-pm-utils )
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.9.10:3
	>=x11-libs/libnotify-0.7.3:0=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxklavier
	virtual/libgudev:=

	colord? ( >=x11-misc/colord-0.1.27:= )
	cups? ( >=net-print/cups-1.4[dbus] )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		x11-drivers/xf86-input-wacom
		x11-libs/libXtst )
	smartcard? ( >=dev-libs/nss-3.11.2 )
	systemd? ( sys-apps/systemd:0= )
	!systemd? ( sys-auth/consolekit:0= )
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	>=dev-util/intltool-0.37.1
	x11-proto/kbproto
	virtual/pkgconfig
"

src_prepare() {
	# make colord and wacom optional
	epatch "${FILESDIR}"/${PN}-2.6.2-optional.patch

	# Disable broken test
	sed -e '/g_test_add_func ("\/color\/edid/d' \
		-i plugins/color/gcm-self-test.c || die

	# Fix intltool unittest
	cat >>"${S}"/po/POTFILES.in <<EOF
data/org.cinnamon.settings-daemon.peripherals.wacom.gschema.xml.in.in
data/org.cinnamon.settings-daemon.plugins.background.gschema.xml.in
data/org.cinnamon.settings-daemon.plugins.background.gschema.xml.in.in
plugins/datetime/org.cinnamon.settingsdaemon.datetimemechanism.policy.in
plugins/keyboard/csd-keyboard-xkb.c
plugins/wacom/csd-wacom-device.c
plugins/wacom/csd-wacom-osd-window.c
plugins/wacom/org.cinnamon.settings-daemon.plugins.wacom.policy.in.in
EOF

	epatch_user

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog MAINTAINERS README"

	# no point in disabling gudev since other plugins pull it in
	gnome2_src_configure \
		--disable-static \
		--enable-gudev \
		--enable-man \
		--enable-polkit \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(use_enable smartcard smartcard-support) \
		$(use_enable systemd logind) \
		$(use_enable input_devices_wacom wacom)
}

src_test() {
	unset DISPLAY
	Xemake check
}
