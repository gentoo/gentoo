# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python{3_4,3_5} )
VALA_MIN_API_VERSION="0.26"

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
	>=dev-db/sqlite-3.4:3
	>=media-libs/gst-rtsp-server-1.4.5:1.0
	media-plugins/gst-plugins-dvb:1.0
	dev-python/gst-python:1.0
	>=dev-python/pygobject-3.2.1:3
	>=dev-libs/gobject-introspection-1.44.0:0
	x11-libs/gtk+:3[introspection]
	virtual/libgudev:0
	vala? ( $(vala_depend) )
	totem? ( media-video/totem )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-lang/perl-5.8.1:0
	>=dev-util/intltool-0.40.0:0
	>=dev-libs/libltdl-2.2.6:0
	virtual/pkgconfig:0
	nls? ( >=sys-devel/gettext-0.18.1:0 )"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang .
	gnome2_src_prepare
	if use vala ; then
		vala_src_prepare
	fi
}

src_configure() {
	gnome2_src_configure \
		$(use_enable nls) \
		$(use_enable totem totem-plugin) \
		$(usex totem '--with-totem-plugin-dir=/usr/$(get_libdir)/totem/plugins' '')
}

pkg_postinst() {
	if use totem ; then
		python_optimize
	fi
	gnome2_pkg_postinst
}

pkg_postrm() {
	if use totem ; then
		python_optimize
	fi
	gnome2_pkg_postrm
}
