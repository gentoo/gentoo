# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Extract closed captioning subtitles from video to SRT"
HOMEPAGE="https://www.ccextractor.org/"
SRC_URI="mirror://sourceforge/ccextractor/${PN}-src-nowin.${PV}.zip"
S="${WORKDIR}/${PN}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip
	virtual/pkgconfig"
RDEPEND="
	media-libs/libpng:0=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch"
	"${FILESDIR}/${PN}-0.85-fno-common.patch"
)

src_install() {
	cmake_src_install
	dodoc ../docs/*.TXT
}
