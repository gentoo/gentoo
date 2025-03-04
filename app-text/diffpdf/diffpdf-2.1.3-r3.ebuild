# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

DESCRIPTION="Program that textually or visually compares two PDF files"
HOMEPAGE="https://web.archive.org/web/20250102202818/https://www.qtrac.eu/diffpdf-foss.html"
SRC_URI="https://web.archive.org/web/20201229194512/http://www.qtrac.eu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	>=dev-build/cmake-3.16
	>=dev-qt/qttools-6.4.2:6[linguist]
"
RDEPEND="
	>=app-text/poppler-22.12[qt6]
	>=dev-qt/qtbase-6.4.2:6[gui,widgets]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-qt5.patch
	"${FILESDIR}"/${P}-qt6.patch
)

src_install() {
	cmake_src_install
	einstalldocs
	doman diffpdf.1
	domenu "${FILESDIR}"/${PN}.desktop
	newicon images/icon.png ${PN}.png
}
