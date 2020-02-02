# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python3_{6,7} )

inherit gnome2 python-single-r1

DESCRIPTION="Setup your DVB devices, record and watch TV shows and browse EPG using GStreamer"
HOMEPAGE="https://wiki.gnome.org/Projects/DVBDaemon"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=dev-libs/glib-2.32.0:2
	dev-libs/libgudev:0
	>=media-libs/gstreamer-1.4.0:1.0
	>=media-libs/gst-plugins-good-1.4.0:1.0
	>=media-libs/gst-plugins-bad-1.4.0:1.0
	>=dev-libs/libgee-0.8:0.8
	>=dev-db/sqlite-3.4:3
	>=media-libs/gst-rtsp-server-1.4.5:1.0
	media-plugins/gst-plugins-dvb:1.0
	dev-python/gst-python:1.0
	>=dev-python/pygobject-3.2.1:3
	>=dev-libs/gobject-introspection-1.44.0:=
	x11-libs/pango[introspection]
	x11-libs/gtk+:3[introspection]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig:0
	>=sys-devel/gettext-0.18.1
"

src_prepare() {
	gnome2_src_prepare
	python_fix_shebang .
}

src_configure() {
	# Prevent sandbox violations, bug #569992
	addpredict /dev
	gnome2_src_configure --disable-totem-plugin
}

src_install() {
	gnome2_src_install
	python_optimize
}
