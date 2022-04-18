# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="cs da de en eo es fi fr hu it nb pl pt_BR ru sv tr uk zh"
inherit desktop plocale qmake-utils xdg

MY_PN="GPXSee"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A viewer and analyzer that supports gpx, tcx, kml, fit, igc and nmea files"
HOMEPAGE="https://www.gpxsee.org/"
SRC_URI="https://github.com/tumic0/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtpositioning:5"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-7.33.patch )

src_prepare() {
	default

	plocale_find_changes lang "${PN}_" '.ts'

	rm_ts() {
		sed -e "s|lang/gpxsee_${1}.ts||" -i gpxsee.pro
	}

	plocale_for_each_disabled_locale rm_ts
}

src_compile() {
	$(qt5_get_bindir)/lrelease gpxsee.pro || die "lrelease failed"
	eqmake5 gpxsee.pro
	emake
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README.md
}
