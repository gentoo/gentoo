# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="cs de fi fr ru sv"
inherit qmake-utils l10n xdg-utils gnome2-utils

MY_PN="GPXSee"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A viewer and analyzer that supports gpx, tcx, kml, fit, igc and nmea files"
HOMEPAGE="http://www.gpxsee.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtnetwork:5
	dev-qt/qtcore:5"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	l10n_find_plocales_changes lang "${PN}_" '.ts'

	rm_ts() {
		sed -e "s|lang/gpxsee_${1}.ts||" -i gpxsee.pro
	}

	l10n_for_each_disabled_locale_do rm_ts
}

src_compile() {
	lrelease gpxsee.pro
	eqmake5 gpxsee.pro
	emake
}

src_install() {
	newbin ${MY_PN} ${PN}
	dodoc README.md
	insinto /usr/share/${PN}
	doins -r pkg/maps pkg/csv
	insinto /usr/share/${PN}/translations
	doins lang/*.qm
	insinto /usr/share/applications
	doins pkg/${PN}.desktop
	insinto /usr/share/mime/packages
	doins pkg/${PN}.xml
	insinto /usr/share/pixmaps
	doins icons/${PN}.png
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
