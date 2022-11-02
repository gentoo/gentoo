# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..11} )
inherit gnome.org gnome2-utils meson python-any-r1 xdg

DESCRIPTION="Note editor designed to remain simple to use"
HOMEPAGE="https://wiki.gnome.org/Apps/Notes"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=app-misc/tracker-3.4.0-r1:3=
	>=dev-libs/glib-2.53.4:2
	net-libs/gnome-online-accounts:=
	>=x11-libs/gtk+-3.19.3:3
	dev-libs/json-glib
	>=gnome-extra/evolution-data-server-3.46.0:=
	>=gui-libs/libhandy-1.0.0:1=
	dev-libs/libxml2:2
	net-misc/curl
	sys-apps/util-linux
	>=net-libs/webkit-gtk-2.26:4.1
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-40.1-meson-0.61.patch
)

src_configure() {
	local emesonargs=(
		-Dupdate_mimedb=false
		-Dprivate_store=false # private store gets automatically enabled with tracker3
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
