# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.5"
VALA_MIN_API_VERSION="0.16"

inherit eutils python gnome2 multilib vala

DESCRIPTION="Setup your DVB devices, record and watch TV shows and browse EPG using GStreamer"
HOMEPAGE="https://live.gnome.org/DVBDaemon"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="nls totem vala"

RDEPEND=">=dev-libs/glib-2.32.0:2
	>=media-libs/gstreamer-0.10.29:0.10
	>=media-libs/gst-plugins-good-0.10.14:0.10
	>=media-libs/gst-plugins-bad-0.10.13:0.10
	>=dev-libs/libgee-0.5:0
	>=dev-db/sqlite-3.4
	>=media-libs/gst-rtsp-server-0.10.7:0.10
	media-plugins/gst-plugins-dvb:0.10
	dev-python/gst-python:0.10
	>=dev-python/pygobject-3.2.1:3
	>=dev-libs/gobject-introspection-0.10.8
	x11-libs/gtk+:3[introspection]
	virtual/libgudev
	vala? ( $(vala_depend) )
	totem? ( media-video/totem )"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.8.1
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.18.1 )
	>=sys-devel/libtool-2.2.6"

pkg_setup() {
	G2CONF="${G2CONF} \
		$(use_enable nls)
		$(use_enable totem totem-plugin)"
	use totem && G2CONF="${G2CONF} \
		--with-totem-plugin-dir=/usr/$(get_libdir)/totem/plugins"

	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_clean_py-compile_files
	python_convert_shebangs -r 2 .
	gnome2_src_prepare
	use vala && vala_src_prepare
}

pkg_postinst() {
	python_mod_optimize gnomedvb
	if use totem; then
		python_mod_optimize "/usr/$(get_libdir)/totem/plugins"
	fi
	gnome2_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup gnomedvb
	if use totem; then
		python_mod_cleanup "/usr/$(get_libdir)/totem/plugins"
	fi
	gnome2_pkg_postrm
}
