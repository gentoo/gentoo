# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="GPXSee"
PLOCALES="ca cs da de en eo es fi fr hu it ko nb pl pt_BR ru sv tr uk zh_CN"
inherit plocale qmake-utils xdg optfeature

DESCRIPTION="Viewer and analyzer that supports gpx, tcx, kml, fit, igc and nmea files"
HOMEPAGE="https://www.gpxsee.org/ https://github.com/tumic0/GPXSee"
SRC_URI="https://github.com/tumic0/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

RDEPEND="
	dev-qt/qtbase:6=[concurrent,gui,network,opengl,sql,widgets]
	dev-qt/qtpositioning:6
	dev-qt/qtsvg:6
"
DEPEND="${RDEPEND}
	dev-qt/qtserialport:6
"
BDEPEND="dev-qt/qttools:6[linguist]"

PATCHES=( "${FILESDIR}"/${PN}-7.33.patch )

src_prepare() {
	default

	plocale_find_changes lang "${PN}_" '.ts'

	rm_ts() {
		sed -e "s|lang/gpxsee_${1}.ts||" -i gpxsee.pro
	}

	plocale_for_each_disabled_locale rm_ts
}

src_configure() {
	$(qt6_get_bindir)/lrelease gpxsee.pro || die "lrelease failed"
	eqmake6 gpxsee.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README.md
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "OpenFreeMap support" dev-qt/qtpbfimageplugin
}
