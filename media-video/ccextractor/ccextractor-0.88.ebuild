# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="Extract closed captioning subtitles from video to SRT"
HOMEPAGE="https://www.ccextractor.org/"
SRC_URI="https://github.com/CCExtractor/ccextractor/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip
	virtual/pkgconfig"
RDEPEND="
	media-libs/libpng:0=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/ccextractor-0.88-fno-common.patch"
	"${FILESDIR}/ccextractor-0.88-libdir.patch"
	"${FILESDIR}/ccextractor-0.88-cflags.patch"
)

src_install() {
	cmake_src_install
	dodoc ../docs/*.TXT
}
