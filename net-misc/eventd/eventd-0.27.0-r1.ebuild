# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info meson systemd

DESCRIPTION="A small daemon to act on remote or local events"
HOMEPAGE="https://www.eventd.org/"
SRC_URI="https://www.eventd.org/download/eventd/${P}.tar.xz"

LICENSE="GPL-3+ LGPL-3+ ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug fbcon +introspection ipv6 libcanberra libnotify +notification
	pulseaudio purple speech systemd test upnp webhook websocket +X zeroconf"

RESTRICT="!test? ( test )"
REQUIRED_USE="
	X? ( notification )
	fbcon? ( notification )
	notification? ( || ( X fbcon ) )
	test? ( websocket )
"

COMMON_DEPEND="
	dev-libs/glib:2
	sys-apps/util-linux
	x11-libs/libxkbcommon
	introspection? ( dev-libs/gobject-introspection )
	libcanberra? ( media-libs/libcanberra )
	libnotify? ( x11-libs/gdk-pixbuf:2 )
	notification? (
		gnome-base/librsvg
		x11-libs/cairo
		x11-libs/pango
		x11-libs/gdk-pixbuf:2
		X? (
			x11-libs/cairo[X,xcb(+)]
			x11-libs/libxcb:=[xkb]
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
	upnp? ( >=net-libs/gssdp-1.2:0= )
	webhook? ( net-libs/libsoup:2.4 )
	websocket? ( net-libs/libsoup:2.4 )
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	fbcon? ( virtual/os-headers )
"
RDEPEND="${COMMON_DEPEND}
	net-libs/glib-networking[ssl]
"
BDEPEND="virtual/pkgconfig"
PATCHES=(
	"${FILESDIR}"/${PN}-0.27.0-fno-common.patch
)

pkg_setup() {
	if use ipv6; then
		CONFIG_CHECK=$(usex test 'IPV6' '~IPV6')
		linux-info_pkg_setup
	fi
}

src_configure() {
	# wayland disabled due to missing dep in ::gentoo, wayland-wall
	local emesonargs=(
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Ddbussessionservicedir="${EPREFIX}/usr/share/dbus-1/services"
		-Dnd-wayland=false
		$(meson_feature websocket)
		$(meson_feature zeroconf dns-sd)
		$(meson_feature upnp ssdp)
		$(meson_use ipv6)
		$(meson_use systemd)
		$(meson_use notification notification-daemon)
		$(meson_use X nd-xcb)
		$(meson_use fbcon nd-fbdev)
		$(meson_use purple im)
		$(meson_use pulseaudio sound)
		$(meson_use speech tts)
		$(meson_use webhook)
		$(meson_use libnotify)
		$(meson_use libcanberra)
		$(meson_use introspection gobject-introspection)
		$(meson_use debug debug-output)
	)

	meson_src_configure
}

src_test() {
	EVENTD_TESTS_TMP_DIR="${T}" meson_src_test
}
