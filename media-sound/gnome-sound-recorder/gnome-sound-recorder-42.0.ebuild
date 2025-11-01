# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )

inherit gnome.org gnome2-utils meson python-any-r1 xdg

DESCRIPTION="A simple, modern sound recorder for GNOME"
HOMEPAGE="https://gitlab.gnome.org/World/vocalis"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

DEPEND="
	>=dev-libs/gjs-1.54.0
	>=dev-libs/glib-2.46:2
	>=gui-libs/gtk-4.4.0:4[introspection]
	media-libs/gst-plugins-bad:1.0
	>=gui-libs/libadwaita-1.1.0:1=
	>=dev-libs/gobject-introspection-1.82.0-r2
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection,ogg]
	x11-libs/gdk-pixbuf:2[introspection]
"
RDEPEND="${DEPEND}
	media-libs/gst-plugins-good:1.0
	media-plugins/gst-plugins-flac:1.0
	media-plugins/gst-plugins-pulse:1.0
"
BDEPEND="
	${PYTHON_DEPS}
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_setup() {
	python-any-r1_pkg_setup
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
