# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop virtualx

DESCRIPTION="Interactive post-processing tool for scanned pages"
HOMEPAGE="http://scantailor.org/ https://github.com/4lex4/scantailor-advanced"
SRC_URI="https://github.com/4lex4/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 GPL-3 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/libpng:0=
	media-libs/tiff:0
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/libXrender
"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-qt/linguist-tools:5
	!media-gfx/scantailor
"

PATCHES=( "${FILESDIR}"/${P}-tests.patch )

src_test() {
	cd "${CMAKE_BUILD_DIR}" || die
	virtx cmake_src_test
}

src_install() {
	cmake_src_install

	newicon resources/appicon.svg ${PN}.svg
	make_desktop_entry ${PN} "Scan Tailor Advanced"
}
