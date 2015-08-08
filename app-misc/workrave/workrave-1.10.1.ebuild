# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2 python-single-r1

DESCRIPTION="Helpful utility to attack Repetitive Strain Injury (RSI)"
HOMEPAGE="http://www.workrave.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="dbus doc distribution gstreamer nls pulseaudio test"

RDEPEND="
	>=dev-libs/glib-2.28.0:2
	>=x11-libs/gtk+-3.0:3
	>=dev-cpp/gtkmm-3.0.0:3.0
	>=dev-cpp/glibmm-2.28.0:2
	>=dev-libs/libsigc++-2.2.4.2:2
	dbus? (
		>=sys-apps/dbus-1.2
		dev-libs/dbus-glib )
	distribution? ( >=net-libs/gnet-2 )
	gstreamer? (
		>=media-libs/gstreamer-0.10:0.10
		>=media-libs/gst-plugins-base-0.10:0.10 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.15 )
	x11-libs/libXScrnSaver
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXt
	x11-libs/libXmu
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	x11-proto/xproto
	x11-proto/inputproto
	x11-proto/recordproto
	dev-python/cheetah
	virtual/pkgconfig
	doc? (
		app-text/docbook-sgml-utils
		app-text/xmlto )
	nls? ( >=sys-devel/gettext-0.17 )
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.10.1-desktop.patch"
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-experimental \
		--disable-static \
		--disable-xml \
		$(use_enable dbus) \
		$(use_enable doc manual) \
		$(use_enable distribution) \
		$(use_enable gstreamer) \
		$(use_enable nls) \
		$(use_enable pulseaudio pulse) \
		$(use_enable test tests)
}
