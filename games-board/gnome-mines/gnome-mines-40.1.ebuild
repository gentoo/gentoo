# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..11} )
inherit gnome.org gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="Clear hidden mines from a minefield"
HOMEPAGE="https://wiki.gnome.org/Apps/Mines"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>=dev-libs/glib-2.40:2
	dev-libs/libgee:0.8
	>=x11-libs/gtk+-3.24:3
	>=dev-libs/libgnome-games-support-1.7.1:1=
	>=gnome-base/librsvg-2.32.0:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	$(vala_depend)
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gnome-base/librsvg:2[vala]
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
