# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson systemd vala xdg

DESCRIPTION="Rygel is an open source UPnP/DLNA MediaServer"
HOMEPAGE="https://wiki.gnome.org/Projects/Rygel"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk gtk-doc +introspection +sqlite tracker test transcode"
RESTRICT="!test? ( test )"

# x11-libs/libX11 from qa-vdb
DEPEND="
	>=net-libs/gupnp-1.5.2:1.6=[vala]
	>=dev-libs/libgee-0.8:0.8=
	>=net-libs/gssdp-1.5.0:1.6=[vala]
	>=dev-libs/glib-2.62.0:2
	>=dev-libs/libxml2-2.7:2
	>=net-libs/gupnp-av-0.14.1:=
	>=media-libs/gupnp-dlna-0.9.4:2.0=
	>=net-libs/libsoup-3:3.0
	sqlite? (
		>=dev-db/sqlite-3.5:3
		dev-libs/libunistring:=
	)
	>=media-libs/gstreamer-1.12:1.0
	>=media-libs/gst-plugins-base-1.12:1.0
	media-libs/gstreamer-editing-services:1.0
	>=media-libs/libmediaart-0.7:2.0[vala]
	media-plugins/gst-plugins-soup:1.0
	x11-libs/gdk-pixbuf:2
	>=sys-apps/util-linux-2.20
	x11-misc/shared-mime-info
	introspection? ( >=dev-libs/gobject-introspection-1.33.4:= )
	tracker? ( app-misc/tracker:3= )
	transcode? (
		media-libs/gst-plugins-bad:1.0
		media-plugins/gst-plugins-twolame:1.0
		media-plugins/gst-plugins-libav:1.0
	)
	gtk? ( >=x11-libs/gtk+-3.22:3 )

	x11-libs/libX11
"
RDEPEND="${DEPEND}"
BDEPEND="
	$(vala_depend)
	app-text/docbook-xml-dtd:4.5
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"
# Maintainer only
#   app-text/docbook-xsl-stylesheets
#	>=dev-lang/vala-0.36
#   dev-libs/libxslt

src_prepare() {
	vala_setup
	default
	# Disable test triggering call to gst-plugins-scanner which causes
	# sandbox issues when plugins such as clutter are installed
	#sed -e 's/return rygel_playbin_renderer_test_main (argv, argc);/return 0;/' \
	#	-i tests/rygel-playbin-renderer-test.c || die

	#default
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc api-docs)
		-Dman_pages=true
		-Dsystemd-user-units-dir=$(systemd_get_userunitdir)
		-Dplugins=gst-launch$(use sqlite && echo ",lms,media-export")$(use tracker && echo ",tracker3")
		-Dengines=gstreamer
		-Dexamples=false
		$(meson_use test tests)
		-Dgstreamer=enabled
		$(meson_feature gtk)
		$(meson_feature introspection)
	)
	meson_src_configure
}
