# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="cs da de en es fi fr nb pl pt_BR pt_PT ru sv tr"
inherit desktop qmake-utils l10n xdg

MY_PN="GPXSee"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A viewer and analyzer that supports gpx, tcx, kml, fit, igc and nmea files"
HOMEPAGE="https://www.gpxsee.org/"
SRC_URI="https://github.com/tumic0/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RDEPEND="dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

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
	local lang
	dobin ${PN}
	dodoc README.md
	insinto /usr/share/${PN}
	doins -r pkg/maps pkg/csv

	insinto /usr/share/${PN}/translations
	for lang in lang/*.qm; do
		[ -f "${lang}" ] && doins "${lang}"
	done

	domenu pkg/${PN}.desktop
	insinto /usr/share/mime/packages
	doins pkg/${PN}.xml
	doicon icons/${PN}.png
}
