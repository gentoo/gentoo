# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils xdg-utils

DESCRIPTION="GTK+-based editor for the Xfce Desktop Environment"
HOMEPAGE="https://git.xfce.org/apps/mousepad/about/"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="
	>=dev-libs/glib-2.52
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/gtksourceview-4.0.0:4
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-lang/perl
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		--enable-gtksourceview4
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
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
