# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Converts pdf files to html files"
HOMEPAGE="http://atrey.karlin.mff.cuni.cz/~clock/twibright/pdf2html/"
SRC_URI="ftp://atrey.karlin.mff.cuni.cz/pub/local/clock/pdf2html/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=">=media-libs/libpng-1.4
	sys-libs/zlib"
RDEPEND="${DEPEND}
	app-text/ghostscript-gpl
	>=media-gfx/imagemagick-6"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-libpng15.patch
}

src_compile() {
	tc-export CC
	# Rewrite the Makefile as that's simpler
	echo "LDLIBS=-lpng" > Makefile
	echo "all: pbm2png" >> Makefile
	emake
	echo "pbm2eps9: pbm2eps9.o printer.o" > Makefile
	emake pbm2eps9

	echo "cp \"${EPREFIX}\"/usr/share/${P}/*.png ." >> pdf2html
}

src_install() {
	dobin pbm2png pbm2eps9 pdf2html ps2eps9

	insinto /usr/share/${P}
	doins *.png *.html

	dodoc CHANGELOG README VERSION
}
