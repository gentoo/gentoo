# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Convert png images to MS ico format"
HOMEPAGE="https://www.kernel.org/pub/software/graphics/pngtoico/"
SRC_URI="https://www.kernel.org/pub/software/graphics/pngtoico/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="media-libs/libpng:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-libpng15.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
