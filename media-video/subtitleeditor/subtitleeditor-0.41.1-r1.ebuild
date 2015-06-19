# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/subtitleeditor/subtitleeditor-0.41.1-r1.ebuild,v 1.4 2015/03/30 02:30:31 tetromino Exp $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 versionator flag-o-matic

DESCRIPTION="GTK+2 subtitle editing tool"
HOMEPAGE="http://home.gna.org/subtitleeditor/"
SRC_URI="http://download.gna.org/${PN}/$(get_version_component_range 1-2)/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug nls opengl"

RDEPEND="
	app-text/iso-codes
	dev-cpp/cairomm
	>=dev-cpp/gtkmm-2.14:2.4
	>=dev-cpp/glibmm-2.16.3:2
	dev-libs/glib:2
	dev-libs/libsigc++:2
	>=dev-cpp/libxmlpp-2.20:2.6
	>=app-text/enchant-1.4
	>=dev-cpp/gstreamermm-0.10.6:0.10
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	>=media-libs/gst-plugins-good-0.10:0.10
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-pango-0.10:0.10
	>=media-plugins/gst-plugins-xvideo-0.10:0.10
	x11-libs/gtk+:2
	virtual/libintl
	opengl? (
		>=dev-cpp/gtkglextmm-1.2:1.0
		virtual/opengl )
"
# gst-plugins-pango needed for text overlay
# gst-plugins-xvideo needed for video output
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"

src_prepare() {
	# Get textoverlay working with gstreamermm 0.10.11
	epatch "${FILESDIR}"/${PN}-0.41.0-textoverlay.patch

	# Prevent crash when generating keyframes with gstreamermm 0.10.11
	epatch "${FILESDIR}"/${PN}-0.41.0-keyframe-generation.patch

	# Fix typing/editing subtitle, bug #536246
	epatch "${FILESDIR}"/${PN}-0.41.0-subtitle-edition.patch

	gnome2_src_prepare
}

src_configure() {
	export GST_REGISTRY="${T}/home/registry.cache.xml"

	# Avoid using --enable-debug as it mocks with CXXFLAGS and LDFLAGS
	use debug && append-flags -DDEBUG

	gnome2_src_configure \
		--disable-debug \
		$(use_enable nls) \
		$(use_enable opengl gl)
}
