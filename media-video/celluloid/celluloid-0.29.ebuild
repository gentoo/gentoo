# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit flag-o-matic gnome2-utils meson python-any-r1 xdg

DESCRIPTION="Simple GTK+ frontend for mpv"
HOMEPAGE="https://celluloid-player.github.io/"
SRC_URI="https://github.com/celluloid-player/celluloid/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64"
IUSE="wayland X"

RDEPEND="
	>=dev-libs/glib-2.68:2
	>=gui-libs/gtk-4.16:4[wayland?,X?]
	>=gui-libs/libadwaita-1.6.0:1
	>=media-video/mpv-0.32:=[libmpv]
	media-libs/libepoxy
	x11-libs/gdk-pixbuf:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/appstream-glib
	>=dev-util/gdbus-codegen-2.80.5-r1
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	# defang automagic dependencies
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11
	use wayland || append-cppflags -DGENTOO_GTK_HIDE_WAYLAND

	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
