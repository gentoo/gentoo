# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils meson vala xdg

DESCRIPTION="Collection of extra plugins for the gedit Text Editor"
HOMEPAGE="https://gitlab.gnome.org/World/gedit/gedit/-/blob/master/plugins/list-of-gedit-plugins.md"
SRC_URI="https://gitlab.gnome.org/World/gedit/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

IUSE="vala"

RDEPEND="
	>=app-editors/gedit-48.2
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.9:3
	gui-libs/libgedit-gtksourceview:300
" # vte-0.52+ for feed_child API compatibility
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-Dplugin_bookmarks=true
		-Dplugin_drawspaces=true
		-Dplugin_smartspaces=true
		-Dplugin_wordcompletion=true
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
