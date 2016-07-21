# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic versionator autotools gnome2

DESCRIPTION="Me TV is a GTK desktop application for watching digital television"
HOMEPAGE="http://me-tv.sourceforge.net/"
SRC_URI="https://launchpad.net/${PN}/$(get_version_component_range 1-2)/$(get_version_component_range 1-3)/+download/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="http"

RDEPEND="
	>=dev-cpp/gconfmm-2.6
	dev-cpp/gtkmm:2.4
	dev-cpp/libxmlpp:2.6
	dev-libs/libunique:1
	>=dev-libs/dbus-glib-0.92
	net-libs/gnet:2
	=dev-db/sqlite-3*
	>=media-video/vlc-1.1.8
	media-libs/gstreamer:0.10
	media-plugins/gst-plugins-xvideo:0.10
	media-libs/gst-plugins-base:0.10
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	append-cxxflags -std=c++11
	epatch "${FILESDIR}"/${P}-gcc47.patch
	eautoreconf
}

src_install() {
	gnome2_src_install
	if use http; then
		dodoc -r http/
	fi
}

pkg_postinst() {
	if use http; then
		elog "The HTTP server port, .. are hardcoded"
	fi
	elog "Please note that Version 1.4 has a new DB so you"
	elog "have to re-import your channels."
}
