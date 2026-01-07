# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit flag-o-matic gnome.org gnome2-utils meson xdg

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="https://apps.gnome.org/Yelp/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
# Removed upstream in 49.beta
IUSE="X"

RDEPEND="
	>=dev-libs/glib-2.67.4:2
	>=x11-libs/gtk+-3.13.3:3[X?]
	>=gui-libs/libhandy-1.5.0:1
	>=dev-libs/libxml2-2.6.5:2=
	>=dev-libs/libxslt-1.1.4
	dev-db/sqlite:3=
	net-libs/webkit-gtk:4.1
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
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11

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
