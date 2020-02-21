# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A series of tools for the PNG image format"
HOMEPAGE="http://www.stillhq.com/pngtools/"
SRC_URI="http://www.stillhq.com/pngtools/source/pngtools_${PV/./_}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="media-libs/libpng:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3-implicit-declarations.patch
	"${FILESDIR}"/${P}-libpng14.patch
	"${FILESDIR}"/${P}-libpng15-fixes.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default
	dodoc ABOUT chunks.txt

	docinto examples
	dodoc *.png
}
