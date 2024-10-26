# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Converts pdf files to html files"
HOMEPAGE="http://atrey.karlin.mff.cuni.cz/~clock/twibright/pdf2html/"
SRC_URI="ftp://atrey.karlin.mff.cuni.cz/pub/local/clock/pdf2html/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND=">=media-libs/libpng-1.4
	sys-libs/zlib"
RDEPEND="${DEPEND}
	app-text/ghostscript-gpl
	>=media-gfx/imagemagick-6"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-libpng15.patch
)

src_compile() {
	tc-export CC
	# Rewrite the Makefile as that's simpler
	echo "LDLIBS=-lpng" > Makefile || die "echo failed"
	echo "all: pbm2png" >> Makefile || die "echo #2 failed"
	emake
	echo "pbm2eps9: pbm2eps9.o printer.o" > Makefile || die "echo #3 failed"
	emake pbm2eps9

	echo "cp \"${EPREFIX}\"/usr/share/${P}/*.png ." >> pdf2html || die "echo #4 failed"
}

src_install() {
	dobin pbm2png pbm2eps9 pdf2html ps2eps9

	insinto /usr/share/${P}
	doins *.png *.html

	dodoc CHANGELOG README VERSION
}
