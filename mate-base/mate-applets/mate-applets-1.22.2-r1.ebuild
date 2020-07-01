# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Applets for the MATE Desktop and Panel"
LICENSE="CC-BY-SA-3.0 FDL-1.1+ GPL-2+ GPL-3+ LGPL-2+"
SLOT="0"

IUSE="X +cpupower ipv6 policykit +upower"

REQUIRED_USE="policykit? ( cpupower )"

COMMON_DEPEND="dev-libs/atk
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.50:2
	>=dev-libs/libmateweather-1.17.0
	>=dev-libs/libxml2-2.5:2
	>=gnome-base/libgtop-2.12.0:2=
	>=gnome-extra/gucharmap-3.0:2.90
	>=mate-base/mate-panel-1.17.0
	>=net-wireless/wireless-tools-28_pre9:0
	>=sys-apps/dbus-1.1.2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/gtksourceview:3.0
	>=x11-libs/libnotify-0.7
	x11-libs/libX11
	>=x11-libs/libwnck-3.0:3
	x11-libs/pango
	virtual/libintl
	cpupower? (
		sys-power/cpupower
		policykit? ( >=sys-auth/polkit-0.97:0 )
	)
	upower? ( >=sys-power/upower-0.9.23 )
	!!net-analyzer/mate-netspeed"

RDEPEND="${COMMON_DEPEND}
	>=mate-base/mate-settings-daemon-1.6"

DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	app-text/rarian
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools
	>=dev-util/intltool-0.50.1
	dev-libs/libxslt
	sys-devel/gettext:*
	virtual/pkgconfig:*"

PATCHES=(
	"${FILESDIR}/${P}-gcc-10-fno-common.patch"
)

src_configure() {

	# configure.ac logic is a little hinky
	# and ignores --enable flags for cpufreq
	use cpupower || myconf="--disable-cpufreq"

	mate_src_configure \
		--libexecdir=/usr/libexec/mate-applets \
		$(use_with X x) \
		$(use_with upower) \
		$(use_enable ipv6) \
		$(use_enable policykit polkit) \
		"${myconf[@]}"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check
}

src_install() {
	mate_src_install

	local APPLETS="accessx-status battstat charpick command cpufreq drivemount
			geyes mateweather multiload netspeed stickynotes
			timerapplet trashapplet"

	for applet in ${APPLETS}; do
		docinto ${applet}

		for d in AUTHORS ChangeLog NEWS README README.themes TODO; do
			[ -s ${applet}/${d} ] && dodoc ${applet}/${d}
		done
	done
}
