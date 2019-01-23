# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit mate python-single-r1

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Applets for the MATE Desktop and Panel"
LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"

IUSE="X ipv6 policykit +upower"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	dev-libs/atk:0
	>=dev-libs/dbus-glib-0.74:0
	>=dev-libs/glib-2.36:2
	>=dev-libs/libmateweather-1.17.0
	>=dev-libs/libxml2-2.5:2
	dev-python/pygobject:3
	>=gnome-base/libgtop-2.12.0:2=
	>=gnome-extra/gucharmap-3.0:2.90
	>=mate-base/mate-panel-1.17.0
	>=net-wireless/wireless-tools-28_pre9:0
	>=sys-apps/dbus-1.1.2:0
	sys-power/cpupower
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.14:3
	x11-libs/gtksourceview:3.0
	>=x11-libs/libnotify-0.7:0
	x11-libs/libX11:0
	>=x11-libs/libwnck-3.0:3
	x11-libs/pango:0
	virtual/libintl:0
	policykit? ( >=sys-auth/polkit-0.97:0 )
	upower? (
			>=sys-power/upower-0.9.23
		)
	!!net-analyzer/mate-netspeed"

RDEPEND="${COMMON_DEPEND}
	>=mate-base/mate-settings-daemon-1.6"

DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	app-text/rarian:0
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools:0
	>=dev-util/intltool-0.50.1:*
	dev-libs/libxslt:0
	sys-devel/gettext:*
	virtual/pkgconfig:*"

PATCHES=( "${FILESDIR}/${PN}-1.16.0-cpupower-4.7.patch" )

src_configure() {
	mate_src_configure \
		--libexecdir=/usr/libexec/mate-applets \
		--with-cpufreq-lib=cpupower \
		$(use_with X x) \
		$(use_with upower) \
		$(use_enable ipv6) \
		$(use_enable policykit polkit)
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check
}

src_install() {
	python_fix_shebang invest-applet
	mate_src_install

	local APPLETS="accessx-status battstat charpick command cpufreq drivemount
			geyes invest-applet mateweather multiload netspeed stickynotes
			timerapplet trashapplet"

	for applet in ${APPLETS}; do
		docinto ${applet}

		for d in AUTHORS ChangeLog NEWS README README.themes TODO; do
			[ -s ${applet}/${d} ] && dodoc ${applet}/${d}
		done
	done
}
