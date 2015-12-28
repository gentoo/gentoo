# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python{3_3,3_4} )
VALA_MIN_API_VERSION="0.25"

inherit eutils gnome2 multilib python-any-r1 vala

DESCRIPTION="Setup your DVB devices, record and watch TV shows and browse EPG using GStreamer"
HOMEPAGE="https://wiki.gnome.org/action/show/Projects/DVBDaemon"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nls totem vala"

RDEPEND=">=dev-libs/glib-2.32.0:2
	>=media-libs/gstreamer-1.4.0:1.0
	>=media-libs/gst-plugins-good-1.4.0:1.0
	>=media-libs/gst-plugins-bad-1.4.0:1.0
	>=dev-libs/libgee-0.8:0.8
	>=dev-db/sqlite-3.4
	>=media-libs/gst-rtsp-server-1.4.5:1.0
	media-plugins/gst-plugins-dvb:1.0
	dev-python/gst-python:1.0
	>=dev-python/pygobject-3.2.1:3
	>=dev-libs/gobject-introspection-1.44.0
	x11-libs/gtk+:3[introspection]
	virtual/libgudev
	vala? ( $(vala_depend) )
	totem? ( media-video/totem )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-lang/perl-5.8.1
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	>=sys-devel/libtool-2.2.6"

pkg_setup() {
	G2CONF="${G2CONF} \
		$(use_enable nls)
		$(use_enable totem totem-plugin)"
	use totem && G2CONF="${G2CONF} \
		--with-totem-plugin-dir=/usr/$(get_libdir)/totem/plugins"
	python-any-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang .
	gnome2_src_prepare
	use vala && vala_src_prepare
}

pkg_postinst() {
	use totem && python_optimize
	gnome2_pkg_postinst
}

pkg_postrm() {
	use totem && python_optimize
	gnome2_pkg_postrm
}
