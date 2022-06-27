# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="fi ru"
inherit desktop plocale qmake-utils xdg

MY_PN="GPXLab"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An application to display and manage GPS tracks"
HOMEPAGE="https://github.com/BourgeoisLab/GPXLab"
SRC_URI="https://github.com/BourgeoisLab/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtnetwork:5"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-0.7.0.patch )

src_prepare() {
	default

	plocale_find_changes ${MY_PN}/locale "${PN}_" '.ts'

	rm_ts() {
		sed -e "s|locale/${PN}_${1}.ts||" -i ${MY_PN}/${MY_PN}.pro
	}

	plocale_for_each_disabled_locale rm_ts
}

src_compile() {
	$(qt5_get_bindir)/lrelease ${MY_PN}.pro || die "lrelease failed"
	eqmake5 ${MY_PN}.pro
	emake
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README.md CHANGELOG.md
}
