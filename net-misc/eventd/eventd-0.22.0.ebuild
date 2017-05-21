# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Convert to a meson eclass when it's ready. Gentoo bug 597182.
inherit flag-o-matic linux-info multiprocessing systemd

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
	test? ( websocket )
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
	>=dev-util/meson-0.39.1
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	fbcon? ( virtual/os-headers )
"
RDEPEND="${COMMON_DEPEND}
	net-libs/glib-networking[ssl]
"

eventd_check_compiler() {
	if [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++11; then
		die "Your compiler lacks C++11 support. Use GCC>=4.7.0 or Clang>=3.3."
	fi
}

pkg_pretend() {
	eventd_check_compiler
}

pkg_setup() {
	if use ipv6; then
		CONFIG_CHECK=$(usex test 'IPV6' '~IPV6')
		linux-info_pkg_setup
	fi
	eventd_check_compiler
}

MESON_BUILD_DIR="${WORKDIR}/${P}_mesonbuild"

src_prepare() {
	default_src_prepare

	# Workaround Gentoo bug 604398.
	sed -i \
		-e 's|libspeechd|speech-dispatcher/libspeechd|g' \
		plugins/tts/src/tts.c || die

	mkdir -p "${MESON_BUILD_DIR}" || die
}

emesonconf() {
	set -- meson \
		--prefix="${EPREFIX}/usr" \
		--libdir="$(get_libdir)" \
		--sysconfdir="${EPREFIX}/etc" \
		--localstatedir="${EPREFIX}/var/lib" \
		--buildtype=plain \
		"${@}" \
		"${MESON_BUILD_DIR}"
	echo "${@}"
	"${@}" || die
}

meson_use_enable() {
	echo "-Denable-${2:-${1}}=$(usex ${1} 'true' 'false')"
}

src_configure() {
	local mymesonargs=(
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Ddbussessionservicedir="${EPREFIX}/usr/share/dbus-1/services"
		$(meson_use_enable websocket)
		$(meson_use_enable zeroconf dns-sd)
		$(meson_use_enable upnp ssdp)
		$(meson_use_enable introspection)
		$(meson_use_enable ipv6)
		$(meson_use_enable systemd)
		$(meson_use_enable notification notification-daemon)
		# Wayland plugin requires wayland-wall, which is currently WIP.
		# See https://github.com/wayland-wall/wayland-wall/issues/1
		-Denable-nd-wayland="false"
		$(meson_use_enable X nd-xcb)
		$(meson_use_enable fbcon nd-fbdev)
		$(meson_use_enable purple im)
		$(meson_use_enable pulseaudio sound)
		$(meson_use_enable speech tts)
		$(meson_use_enable libnotify)
		$(meson_use_enable libcanberra)
		$(meson_use_enable debug)
	)

	emesonconf "${mymesonargs[@]}"
}

eninja() {
	if [[ -z ${NINJAOPTS+set} ]]; then
		NINJAOPTS="-j$(makeopts_jobs) -l$(makeopts_loadavg)"
	fi
	set -- ninja -v ${NINJAOPTS} -C "${MESON_BUILD_DIR}" "${@}"
	echo "${@}"
	"${@}" || die
}

src_compile() {
	eninja
}

src_install() {
	DESTDIR="${ED%/}" eninja install
	einstalldocs
}

src_test() {
	local -x EVENTD_TESTS_TMP_DIR="${T}"
	eninja test
}

pkg_postinst() {
	if { use notification || use libnotify; } && ! has_version 'gnome-base/librsvg'; then
		elog
		elog "For SVG icons in notifications, please install 'gnome-base/librsvg'."
		elog
	fi
}
