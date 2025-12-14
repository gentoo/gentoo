# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="A simple text editor for the GNOME desktop"
HOMEPAGE="https://apps.gnome.org/TextEditor/"
S="${WORKDIR}/gnome-text-editor-${PV/_/.}"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

IUSE="+editorconfig"

DEPEND="
	>=dev-libs/glib-2.80.0:2
	>=gui-libs/gtk-4.19.4:4
	>=gui-libs/gtksourceview-5.15.0:5
	>=gui-libs/libadwaita-1.8_alpha:1
	app-text/editorconfig-core-c
	>=app-text/libspelling-0.4.0
"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas
"
BDEPEND="
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.21
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature editorconfig)
		-Dbugreport_url="https://bugs.gentoo.org"
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
