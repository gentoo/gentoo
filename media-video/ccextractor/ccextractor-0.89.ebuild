# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Extract closed captioning subtitles from video to SRT"
HOMEPAGE="https://ccextractor.org/"
SRC_URI="https://github.com/CCExtractor/ccextractor/archive/v${PV}.tar.gz -> ${P}.tar.gz"
CMAKE_USE_DIR="${S}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	app-arch/unzip
	virtual/pkgconfig"
RDEPEND="
	media-libs/libpng:0=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-libdir.patch"
	"${FILESDIR}/${P}-cflags.patch"
	"${FILESDIR}/${P}-cmake4.patch" # bug 953940
)

src_install() {
	cmake_src_install
	dodoc docs/*.TXT
}
