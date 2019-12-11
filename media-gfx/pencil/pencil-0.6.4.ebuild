# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop l10n qmake-utils xdg-utils

DESCRIPTION="2D animation and drawing program based on Qt5"
HOMEPAGE="https://www.pencil2d.org/"
SRC_URI="https://github.com/pencil2d/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
PLOCALES="ca cs da de el es et fr he hu_HU id it ja kab pl pt pt_BR ru sl vi zh_CN zh_TW"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	einstalldocs

	newbin bin/pencil2d ${PN}

	newicon app/data/icons/icon.png ${PN}.png
	make_desktop_entry ${PN} pencil2d ${PN} Graphics

	insinto /usr/share/mime/packages/
	doins app/data/pencil2d.xml
	dodoc LICENSE.TXT

	l10n_find_plocales_changes "${S}/translations" "${PN}_" '.ts'
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
