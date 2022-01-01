# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PLOCALES="cs de es eu fr id ie it ko nb nl nn pt_BR ru sv tr uk zh_CN zh_TW"
inherit meson plocale xdg-utils gnome2-utils
SRC_URI="https://github.com/johnfactotum/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="gtk ebook reader built with gjs"
HOMEPAGE="https://github.com/johnfactotum/foliate/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="handy spell"

BDEPEND="${MESON_DEPEND}
	sys-devel/gettext"
RDEPEND="dev-libs/gjs
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	net-libs/webkit-gtk:4[introspection]
	handy? ( gui-libs/libhandy:=[introspection] )
	spell? ( app-text/gspell[introspection] )"

src_prepare() {
	default

	plocale_find_changes "${S}"/po '' '.po'

	rm_po() {
		rm po/${1}.po
		sed -e "/^${1}/d" -i po/LINGUAS
	}

	plocale_for_each_disabled_locale rm_po
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
	gnome2_schemas_update
}
