# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2 systemd virtualx

DESCRIPTION="Rygel is an open source UPnP/DLNA MediaServer"
HOMEPAGE="https://wiki.gnome.org/Projects/Rygel"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="X +introspection +sqlite tracker test transcode"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=dev-libs/libgee-0.8:0.8
	>=dev-libs/libxml2-2.7:2
	>=media-libs/gupnp-dlna-0.9.4:2.0
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	>=media-libs/libmediaart-0.7:2.0
	media-plugins/gst-plugins-soup:1.0
	>=net-libs/gssdp-0.14.15
	>=net-libs/gupnp-0.20.14
	>=net-libs/gupnp-av-0.12.8
	>=net-libs/libsoup-2.44:2.4
	>=sys-apps/util-linux-2.20
	x11-misc/shared-mime-info
	introspection? ( >=dev-libs/gobject-introspection-1.33.4:= )
	sqlite? (
		>=dev-db/sqlite-3.5:3
		dev-libs/libunistring:=
		x11-libs/gdk-pixbuf:2
	)
	tracker? ( app-misc/tracker:= )
	transcode? (
		media-libs/gst-plugins-bad:1.0
		media-plugins/gst-plugins-twolame:1.0
		media-plugins/gst-plugins-libav:1.0
	)
	X? ( >=x11-libs/gtk+-3:3 )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"
# Maintainer only
#   app-text/docbook-xsl-stylesheets
#	>=dev-lang/vala-0.22
#   dev-libs/libxslt

src_prepare() {
	# Disable test triggering call to gst-plugins-scanner which causes
	# sandbox issues when plugins such as clutter are installed
	sed -e 's/return rygel_playbin_renderer_test_main (argv, argc);/return 0;/' \
		-i tests/rygel-playbin-renderer-test.c || die

	gnome2_src_prepare
}

src_configure() {
	# We set xsltproc because man pages are provided by upstream
	# and we do not want to regenerate them automagically.
	gnome2_src_configure \
		XSLTPROC=$(type -P false) \
		--enable-gst-launch-plugin \
		--with-media-engine=gstreamer \
		--enable-nls \
		--with-systemduserunitdir=$(systemd_get_userunitdir) \
		$(use_enable introspection) \
		$(use_enable sqlite media-export-plugin) \
		$(use_enable sqlite lms-plugin) \
		$(use_enable test tests) \
		$(use_enable tracker tracker-plugin) \
		$(use_with X ui)
}
