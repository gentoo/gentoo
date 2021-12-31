# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Convert png images to MS ico format"
HOMEPAGE="https://www.kernel.org/pub/software/graphics/pngtoico/"
SRC_URI="https://www.kernel.org/pub/software/graphics/pngtoico/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND=">=media-libs/libpng-1.4"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-Makefile.patch \
		"${FILESDIR}"/${P}-libpng15.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
