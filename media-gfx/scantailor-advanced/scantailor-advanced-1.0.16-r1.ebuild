# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake virtualx xdg

DESCRIPTION="Interactive post-processing tool for scanned pages"
HOMEPAGE="https://scantailor.org/ https://github.com/4lex4/scantailor-advanced"
SRC_URI="https://github.com/4lex4/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 GPL-3 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	dev-qt/linguist-tools:5
"
COMMON_DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/libpng:0=
	media-libs/tiff:0
	sys-libs/zlib
	virtual/jpeg:0
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	dev-qt/qtsvg:5
"

PATCHES=(
	"${FILESDIR}"/${P}-tests.patch # bug 662004
	"${FILESDIR}"/${P}-qt-5.15.patch # bug 726066
	"${FILESDIR}"/${P}-desktopfile.patch
	"${FILESDIR}"/${P}-bogus-dep.patch
)

src_prepare() {
	cmake_src_prepare
}

src_test() {
	cd "${CMAKE_BUILD_DIR}" || die
	virtx cmake_src_test
}
