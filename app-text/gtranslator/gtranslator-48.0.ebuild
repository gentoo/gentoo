# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="GNOME Translation Editor"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gtranslator/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="
	>=dev-libs/glib-2.71.3:2
	>=gui-libs/gtk-4.12.0:4
	>=gui-libs/libadwaita-1.6_alpha
	gnome-extra/libgda:5=[-http]
	gnome-base/gsettings-desktop-schemas
	>=gui-libs/gtksourceview-5.4.0:5
	>=dev-libs/libxml2-2.4.12:2=
	net-libs/libsoup:3.0
	>=dev-libs/json-glib-1.2.0
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-45.2-Revert-Add-GDA-6-compatibility.patch
)

src_configure() {
	local emesonargs=(
		-Dprofile=default
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
