# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="sqlite"

inherit gnome.org meson python-single-r1 xdg

DESCRIPTION="A non-linear video editor using the GStreamer multimedia framework"
HOMEPAGE="https://www.pitivi.org"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Do not forget to check pitivi/check.py for dependencies!!!
# gsound, libav, libnotify and v4l are optional
GST_VER="1.18.4"

COMMON_DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/pycairo-1.10[${PYTHON_USEDEP}]
	')
	>=x11-libs/cairo-1.10

	>=media-libs/gstreamer-${GST_VER}:1.0[introspection]
"
RDEPEND="${COMMON_DEPEND}
	>=dev-libs/glib-2.30.0:2

	>=dev-libs/gobject-introspection-1.34:=

	dev-libs/libpeas[${PYTHON_SINGLE_USEDEP}]

	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		>=dev-python/gst-python-1.4:1.0[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3.8:3[${PYTHON_USEDEP}]
	')

	gnome-base/librsvg:=

	>=media-libs/gstreamer-editing-services-${GST_VER}:1.0[introspection]
	>=media-libs/gst-plugins-base-${GST_VER}:1.0[introspection,theora]
	>=media-libs/gst-plugins-bad-${GST_VER}:1.0
	>=media-plugins/gst-plugins-gtk-${GST_VER}:1.0
	>=media-libs/gst-plugins-good-${GST_VER}:1.0
	>=media-plugins/gst-plugins-libav-${GST_VER}:1.0
	>=media-plugins/gst-plugins-gdkpixbuf-${GST_VER}:1.0

	>=x11-libs/libnotify-0.7[introspection]
	x11-libs/libwnck:3[introspection]
	>=x11-libs/gtk+-3.20.0:3[introspection]
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/yelp-tools
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	>=dev-util/intltool-0.35.5
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
	python_fix_shebang "${D}"
}
