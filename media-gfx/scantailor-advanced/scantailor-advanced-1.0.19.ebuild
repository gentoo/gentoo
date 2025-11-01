# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Interactive post-processing tool for scanned pages"
HOMEPAGE="https://github.com/ScanTailor-Advanced/scantailor-advanced"
SRC_URI="https://github.com/ScanTailor-Advanced/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 GPL-3 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

COMMON_DEPEND="
	dev-qt/qtbase:6[gui,opengl,widgets,xml]
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/tiff:=
	sys-libs/zlib
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	dev-qt/qtsvg:6
"
BDEPEND="dev-qt/qttools:6[linguist]"

PATCHES=(
	"${FILESDIR}"/${P}-missing-header.patch # git master
	"${FILESDIR}"/${P}-bogus-dep.patch # TODO: upstream
)

CMAKE_SKIP_TESTS=( imageproc_tests ) # bug 662004

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	cmake_src_test
}
