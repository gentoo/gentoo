# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit flag-o-matic gnome2 versionator

DESCRIPTION="GTK+3 subtitle editing tool"
HOMEPAGE="http://home.gna.org/subtitleeditor/"
SRC_URI="http://download.gna.org/${PN}/$(get_version_component_range 1-2)/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug nls"
# opengl would mix gtk+:2 and :3 which is not possible

RDEPEND="
	>=app-text/enchant-1.4
	app-text/iso-codes
	>=dev-cpp/cairomm-1.12
	>=dev-cpp/glibmm-2.46:2
	>=dev-cpp/gtkmm-3.18:3.0
	>=dev-cpp/gstreamermm-1.0:1.0
	>=dev-cpp/libxmlpp-2.40:2.6
	dev-libs/glib:2
	>=dev-libs/libsigc++-2.6:2
	media-libs/gst-plugins-base:1.0[X,pango]
	media-libs/gst-plugins-good:1.0
	media-libs/gstreamer:1.0
	media-plugins/gst-plugins-meta:1.0
	x11-libs/gtk+:3
	virtual/libintl
"
#	opengl? (
#		>=dev-cpp/gtkglextmm-1.2.0-r2:1.0
#		virtual/opengl )
# X needed for video output and pango needed for text overlay
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"

src_prepare() {
	# ansi overrides -std, see src_configure
	sed 's/\(CXXFLAGS\) -ansi/\1/' -i configure.ac configure || die

	# fix build issues
	epatch "${FILESDIR}"/${PN}-0.52.1-build-fix.patch

	gnome2_src_prepare
}

src_configure() {
	# Needed with newer gnome mm bindings
	append-cxxflags -std=c++11

	# Avoid using --enable-debug as it mocks with CXXFLAGS and LDFLAGS
	use debug && append-cxxflags -DDEBUG

	gnome2_src_configure \
		--disable-debug \
		--disable-gl \
		$(use_enable nls)
#		$(use_enable opengl gl)
}
