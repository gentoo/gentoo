# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

DESCRIPTION="Program that textually or visually compares two PDF files"
HOMEPAGE="https://www.qtrac.eu/diffpdf.html"
SRC_URI="http://www.qtrac.eu/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

BDEPEND="dev-qt/linguist-tools:5"
RDEPEND="
	app-text/poppler[qt5]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-qt5.patch )

src_configure() {
	$(qt5_get_bindir)/lrelease diffpdf.pro || die "Generating translations failed"
	eqmake5 PREFIX="${EPREFIX}/usr" diffpdf.pro
}

src_install() {
	einstalldocs
	dobin diffpdf
	doman diffpdf.1
	domenu "${FILESDIR}"/${PN}.desktop
	newicon images/icon.png ${PN}.png
}
