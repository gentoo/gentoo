# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Personal task manager"
HOMEPAGE="https://wiki.gnome.org/Apps/Todo https://gitlab.gnome.org/World/Endeavour"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/World/Endeavour.git"
	SRC_URI=""
else
	SRC_URI="https://gitlab.gnome.org/World/${PN^}/-/archive/${PV}/${PN^}-${PV}.tar.bz2"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN^}-${PV}"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.58.0:2
	>=gui-libs/gtk-3.92.0:4[introspection?]
	>=gui-libs/libadwaita-1.2.0:1
	>=net-libs/gnome-online-accounts-3.2.0:=
	>=dev-libs/libpeas-1.17
	>=gnome-extra/evolution-data-server-3.33.2:=[gtk]
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2:2
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	# TODO: There aren't any consumers of the introspection outside gnome-todo's own plugins, so maybe we
	# TODO: should just always build introspection support as an application that needs it for full functionality?
	local emesonargs=(
		$(meson_use introspection)
		-Dtracing=false
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
