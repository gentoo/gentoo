# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )
inherit gnome.org gnome2-utils meson python-any-r1 xdg

DESCRIPTION="Note editor designed to remain simple to use"
HOMEPAGE="https://gitlab.gnome.org/GNOME/bijiben"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=app-misc/tinysparql-3.4.0-r1:3=
	>=dev-libs/glib-2.53.4:2
	net-libs/gnome-online-accounts:=
	>=x11-libs/gtk+-3.19.3:3
	dev-libs/json-glib
	>=gnome-extra/evolution-data-server-3.46.0:=
	>=gui-libs/libhandy-1.0.0:1=
	dev-libs/libxml2:2=
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
