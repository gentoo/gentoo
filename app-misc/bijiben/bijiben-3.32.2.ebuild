# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Note editor designed to remain simple to use"
HOMEPAGE="https://wiki.gnome.org/Apps/Notes"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	app-misc/tracker:0/2.0
	>=dev-libs/glib-2.53.4:2
	net-libs/gnome-online-accounts:=
	>=x11-libs/gtk+-3.19.3:3
	>=gnome-extra/evolution-data-server-3.13.90:=
	dev-libs/libxml2:2
	sys-apps/util-linux
	>=net-libs/webkit-gtk-2.10:4
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dzeitgeist=false
		-Dupdate_mimedb=false
		-Dprivate_store=false # private store is mainly meant for flatpak builds
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
