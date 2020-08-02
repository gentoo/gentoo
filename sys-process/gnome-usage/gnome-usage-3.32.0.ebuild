# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
VALA_MIN_API_VERSION="0.36"
VALA_USE_DEPEND="vapigen"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="A nice way to view information about use of system resources."
HOMEPAGE="https://wiki.gnome.org/Apps/Usage"

LICENSE="GPL-3+"
SLOT="0"
IUSE=""
KEYWORDS="amd64"

RDEPEND="
	>=dev-libs/glib-2.38:2
	>=x11-libs/gtk+-3.20.10:3
	>=dev-libs/libdazzle-3.30
	>=gnome-base/libgtop-2.34.0:2
"

DEPEND="${RDEPEND}
	${vala_depend}
	>=sys-devel/gettext-0.19.8
"

src_prepare() {
	vala_src_prepare
	default
}

src_configure() {
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
