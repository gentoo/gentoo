# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info systemd xdg-utils

DESCRIPTION="A small daemon to act on remote or local events"
HOMEPAGE="https://www.eventd.org/"
SRC_URI="https://www.eventd.org/download/${PN}/${P}.tar.xz"

LICENSE="GPL-3+ LGPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug fbcon +introspection ipv6 libcanberra libnotify +notification
	pulseaudio purple speech systemd test upnp websocket +X zeroconf"

REQUIRED_USE="
	X? ( notification )
	fbcon? ( notification )
	notification? ( || ( X fbcon ) )
"

COMMON_DEPEND="
	>=dev-libs/glib-2.40:2
	sys-apps/util-linux
	introspection? ( >=dev-libs/gobject-introspection-1.42 )
	libcanberra? ( media-libs/libcanberra )
	libnotify? ( x11-libs/gdk-pixbuf:2 )
	notification? (
		x11-libs/cairo
		x11-libs/pango
		x11-libs/gdk-pixbuf:2
		X? (
			x11-libs/cairo[xcb]
			x11-libs/libxcb:=
			x11-libs/xcb-util
			x11-libs/xcb-util-wm
		)
	)
	pulseaudio? (
		media-libs/libsndfile
		media-sound/pulseaudio
	)
	purple? ( net-im/pidgin )
	speech? ( app-accessibility/speech-dispatcher )
	systemd? ( sys-apps/systemd:= )
	upnp? ( net-libs/gssdp:= )
	websocket? ( >=net-libs/libsoup-2.50:2.4 )
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	fbcon? ( virtual/os-headers )
"
RDEPEND="${COMMON_DEPEND}
	net-libs/glib-networking[ssl]
"

pkg_setup() {
	if use ipv6; then
		CONFIG_CHECK=$(usex test 'IPV6' '~IPV6')
		linux-info_pkg_setup
	fi
}

src_prepare() {
	default_src_prepare

	# Workaround Gentoo bug 604398.
	sed -i \
		-e 's|libspeechd|speech-dispatcher/libspeechd|g' \
		plugins/tts/src/tts.c || die

	# Prevent access violations from introspection metadata generation.
	xdg_environment_reset
}

src_configure() {
	local myeconfargs=(
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-dbussessionservicedir="${EPREFIX}/usr/share/dbus-1/services"
		$(use_enable websocket)
		$(use_enable zeroconf dns-sd)
		$(use_enable upnp ssdp)
		$(use_enable introspection)
		$(use_enable ipv6)
		$(use_enable systemd)
		$(use_enable notification notification-daemon)
		# Wayland plugin requires wayland-wall, which is currently WIP.
		# See https://github.com/wayland-wall/wayland-wall/issues/1
		--disable-nd-wayland
		$(use_enable X nd-xcb)
		$(use_enable fbcon nd-fbdev)
		$(use_enable purple im)
		$(use_enable pulseaudio sound)
		$(use_enable speech tts)
		$(use_enable libnotify)
		$(use_enable libcanberra)
		$(use_enable debug)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	local -x EVENTD_TESTS_TMP_DIR="${T}"
	default_src_test
}

pkg_postinst() {
	if { use notification || use libnotify; } && ! has_version 'gnome-base/librsvg'; then
		elog
		elog "For SVG icons in notifications, please install 'gnome-base/librsvg'."
		elog
	fi
}
