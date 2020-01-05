# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit gnome2-utils meson python-single-r1 xdg-utils

DESCRIPTION="Tethered Camera Control & Capture"
HOMEPAGE="https://entangle-photo.org/"
SRC_URI="https://entangle-photo.org/download/sources/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.36:2
	>=dev-libs/gobject-introspection-1.54.0
	dev-libs/libgudev:=
	>=dev-libs/libpeas-1.2.0[gtk,${PYTHON_SINGLE_USEDEP}]
	>=media-libs/gexiv2-0.10[introspection]
	>=media-libs/libgphoto2-2.5.0:=
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/lcms:2
	>=media-libs/libraw-0.9.0
	>=x11-libs/gdk-pixbuf-2.12.0:2
	>=x11-libs/gtk+-3.22:3[introspection]
	>=x11-libs/libXext-1.3.0
	x11-themes/adwaita-icon-theme"
RDEPEND="${DEPEND}"

# perl for pod2man
BDEPEND="
	app-text/yelp-tools
	dev-lang/perl
	dev-util/glib-utils
	dev-util/gtk-doc
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig"

src_compile() {
	# prevent gst from loading system plugins which causes
	# sandbox violations on device access
	local -x GST_PLUGIN_SYSTEM_PATH_1_0=
	meson_src_compile
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	gnome2_schemas_update
}
