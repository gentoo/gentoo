# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils xdg-utils

DESCRIPTION="GTK+-based editor for the Xfce Desktop Environment"
HOMEPAGE="
	https://docs.xfce.org/apps/mousepad/start
	https://gitlab.xfce.org/apps/mousepad/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv x86"
IUSE="policykit spell +shortcuts"

DEPEND="
	>=dev-libs/glib-2.56.2
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/gtksourceview-4.0.0:4
	policykit? ( sys-auth/polkit )
	spell? ( app-text/gspell )
	shortcuts? ( >=xfce-base/libxfce4ui-4.17.5:= )
"
RDEPEND="
	${DEPEND}
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
		$(use_enable policykit polkit)
		$(use_enable spell plugin-gspell)
		$(use_enable shortcuts plugin-shortcuts)
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
