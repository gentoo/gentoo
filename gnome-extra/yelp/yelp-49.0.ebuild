# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="https://apps.gnome.org/Yelp/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-libs/glib-2.67.4:2
	>=gui-libs/gtk-4.16.0:4
	>=gui-libs/libadwaita-1.6.0:1
	>=dev-libs/libxml2-2.6.5:2=
	>=dev-libs/libxslt-1.1.4
	dev-db/sqlite:3=
	net-libs/webkit-gtk:6
	>=gnome-extra/yelp-xsl-42.3
	>=app-arch/xz-utils-4.9:=
	app-arch/bzip2:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/itstool-1.2.0
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dlzma=enabled
		-Dbzip2=enabled
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
