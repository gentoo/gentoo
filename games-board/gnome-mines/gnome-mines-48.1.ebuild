# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )

inherit gnome.org gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="Clear hidden mines from a minefield"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-mines"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	>=dev-libs/glib-2.40:2
	dev-libs/libgee:0.8
	>=gui-libs/gtk-4.6:4
	gui-libs/libadwaita:1
	dev-libs/libgnome-games-support:2=
	>=gnome-base/librsvg-2.32.0:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	$(vala_depend)
	dev-libs/appstream
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gnome-base/librsvg:2[vala]
"

src_prepare() {
	default
	vala_setup
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
