# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_3,3_4,3_5} )
PYTHON_REQ_USE="sqlite"

inherit gnome2 python-single-r1 virtualx

DESCRIPTION="A non-linear video editor using the GStreamer multimedia framework"
HOMEPAGE="http://www.pitivi.org"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="v4l test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Do not forget to check pitivi/check.py for dependencies
# pycanberra, gnome-desktop, libav and libnotify are optional
COMMON_DEPEND="
	${PYTHON_DEPS}
	>=dev-python/pycairo-1.10[${PYTHON_USEDEP}]
	>=x11-libs/cairo-1.10
"
RDEPEND="${COMMON_DEPEND}
	>=dev-libs/glib-2.30.0:2

	>=dev-libs/gobject-introspection-1.34:=
	dev-python/dbus-python[${PYTHON_USEDEP}]
	>=dev-python/gst-python-1.4:1.0[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pycanberra[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.8:3[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]

	gnome-base/librsvg:=
	gnome-base/gnome-desktop:3=[introspection]

	>=media-libs/gstreamer-1.6.0:1.0[introspection]
	>=media-libs/gstreamer-editing-services-1.6.0:1.0[introspection]
	>=media-libs/gst-plugins-base-1.6.0:1.0
	>=media-libs/gst-plugins-bad-1.6.1:1.0[gtk]
	>=media-libs/gst-plugins-good-1.6.0:1.0
	>=media-plugins/gst-plugins-libav-1.6.0:1.0

	x11-libs/libnotify[introspection]
	>=x11-libs/gtk+-3.10.0:3[introspection]

	v4l? ( >=media-plugins/gst-plugins-v4l2-1.4:1.0 )
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-python/setuptools
	>=dev-util/intltool-0.35.5
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

src_configure() {
	gnome2_src_configure \
		--disable-static
}

src_test() {
	# Force Xvfb to be used
	unset DISPLAY
	export PITIVI_TOP_LEVEL_DIR="${S}"
	Xemake check
}

src_install() {
	gnome2_src_install
	python_fix_shebang "${D}"
}
