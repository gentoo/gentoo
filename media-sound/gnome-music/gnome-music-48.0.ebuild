# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )

inherit gnome.org gnome2-utils meson python-single-r1 xdg

DESCRIPTION="Music management for Gnome"
HOMEPAGE="https://apps.gnome.org/Music/"

LICENSE="GPL-2+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.67.1:2
	>=dev-libs/gobject-introspection-1.54:=
	>=gui-libs/gtk-4.16.0:4[introspection]
	>=gui-libs/libadwaita-1.6:1=[introspection]
	>=media-libs/libmediaart-1.9.1:2.0[introspection]
	net-libs/libsoup:3.0[introspection]
	app-misc/tinysparql:3=[introspection(+)]
	>=x11-libs/pango-1.44:=
	$(python_gen_cond_dep '
		>=dev-python/pygobject-3.50.0:3[cairo,${PYTHON_USEDEP}]
		>=dev-python/pycairo-1.14.0[${PYTHON_USEDEP}]
	')
	>=media-libs/grilo-0.3.15-r1:0.3[introspection]
	>=media-plugins/grilo-plugins-0.3.16:0.3[tracker]
"
# xdg-user-dirs-update needs to be there to create needed dirs
# https://bugzilla.gnome.org/show_bug.cgi?id=731613
RDEPEND="${DEPEND}
	|| (
		app-misc/localsearch:3[gstreamer]
		app-misc/localsearch:3[ffmpeg]
	)
	x11-libs/libnotify[introspection]
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	media-plugins/gst-plugins-meta:1.0
	media-plugins/grilo-plugins:0.3[tracker]
	x11-misc/xdg-user-dirs
"
BDEPEND="
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_setup() {
	python_setup
}

src_install() {
	meson_src_install
	python_fix_shebang "${D}"/usr/bin/gnome-music
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
