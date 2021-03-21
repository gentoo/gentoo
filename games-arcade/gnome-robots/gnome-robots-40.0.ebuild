# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Avoid the robots and make them crash into each other"
HOMEPAGE="https://wiki.gnome.org/Apps/Robots https://gitlab.gnome.org/GNOME/gnome-robots"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/libgee-0.8:=
	>=dev-libs/glib-2.32:2
	>=dev-libs/libgnome-games-support-1.7.1:1=
	>=media-libs/gsound-1.0.2
	>=x11-libs/gtk+-3.24:3
	>=gnome-base/librsvg-2.36.2:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	${vala_depend}
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare
	xdg_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
