# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PLOCALES="cs_CS de_DE es fr_FR id_ID ie it nl pt_BR ru_RU sv tr uk zh_CN zh_TW"
inherit meson l10n xdg-utils gnome2-utils
SRC_URI="https://github.com/johnfactotum/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="gtk ebook reader built with gjs"
HOMEPAGE="https://github.com/johnfactotum/foliate/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="${MESON_DEPEND}
	sys-devel/gettext"
RDEPEND="dev-libs/gjs
	net-libs/webkit-gtk"

src_prepare() {
	default

	l10n_find_plocales_changes "${S}"/po '' '.po'

	rm_po() {
		rm po/${1}.po
		sed -e "/^${1}/d" -i po/LINGUAS
	}

	l10n_for_each_disabled_locale_do rm_po
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
