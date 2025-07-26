# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gnome2-utils meson xdg-utils

DESCRIPTION="GTK+-based editor for the Xfce Desktop Environment"
HOMEPAGE="
	https://docs.xfce.org/apps/mousepad/start
	https://gitlab.xfce.org/apps/mousepad/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
IUSE="policykit spell +shortcuts X"

DEPEND="
	>=dev-libs/glib-2.56.2
	>=x11-libs/gtk+-3.22.0:3[X?]
	>=x11-libs/gtksourceview-4.0.0:4
	policykit? ( >=sys-auth/polkit-0.102 )
	spell? ( >=app-text/gspell-1.6.0:= )
	shortcuts? ( >=xfce-base/libxfce4ui-4.17.5:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	# defang automagic dependencies
	use X || append-flags -DGENTOO_GTK_HIDE_X11

	local emesonargs=(
		-Dgtksourceview4=enabled
		$(meson_feature policykit polkit)
		$(meson_feature spell gspell-plugin)
		$(meson_feature shortcuts shortcuts-plugin)
	)
	meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}
