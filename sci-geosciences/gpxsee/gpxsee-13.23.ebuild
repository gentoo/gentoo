# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="ca cs da de en eo es fi fr hu it ko nb pl pt_BR ru sv tr uk zh"
inherit plocale qmake-utils xdg

MY_PN="GPXSee"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A viewer and analyzer that supports gpx, tcx, kml, fit, igc and nmea files"
HOMEPAGE="https://www.gpxsee.org/ https://github.com/tumic0/GPXSee"
SRC_URI="https://github.com/tumic0/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="qt6"

RDEPEND="
	qt6? (
		dev-qt/qtbase:6
		dev-qt/qtpositioning:6
		dev-qt/qtserialport:6
	)
	!qt6? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtpositioning:5
		dev-qt/qtprintsupport:5
		dev-qt/qtserialport:5
		dev-qt/qtsql:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	qt6? ( dev-qt/qttools:6 )
	!qt6? ( dev-qt/linguist-tools:5 )
"

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
	if use qt6; then
		$(qt6_get_bindir)/lrelease gpxsee.pro || die "lrelease failed"
		eqmake6 gpxsee.pro
	else
		$(qt5_get_bindir)/lrelease gpxsee.pro || die "lrelease failed"
		eqmake5 gpxsee.pro
	fi
	emake
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README.md
}
