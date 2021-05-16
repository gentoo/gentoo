# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION="0.24"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Disassemble a pile of tiles by removing matching pairs"
HOMEPAGE="https://wiki.gnome.org/Apps/Mahjongg"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=x11-libs/gtk+-3.13.2:3
	>=gnome-base/librsvg-2.32.0:2
"
DEPEND="${RDEPEND}
	gnome-base/librsvg:2[vala]
"
BDEPEND="
	$(vala_depend)
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dcompile-schemas=disabled
		-Dupdate-icon-cache=disabled
	)
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
