# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Unicode character map viewer and library"
HOMEPAGE="https://apps.gnome.org/Characters/"

LICENSE="GPL-2+ BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/gjs-1.50
	>=dev-libs/glib-2.32:2
	>=dev-libs/gobject-introspection-1.35.9:=
	>=gui-libs/gtk-4.6:4[introspection]
	>=gui-libs/libadwaita-1.4:1=
	x11-libs/gdk-pixbuf:2
	>=x11-libs/pango-1.36[introspection]
	gnome-base/gnome-desktop:4
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/glib
	dev-libs/libxml2:2
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( x11-misc/xvfb-run )
"

src_test() {
	meson test -C "${BUILD_DIR}" || die 'tests failed'
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
