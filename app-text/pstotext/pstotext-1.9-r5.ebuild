# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Extract ASCII text from a PostScript or PDF file"
HOMEPAGE="http://www.cs.wisc.edu/~ghost/doc/pstotext.htm"
SRC_URI="ftp://mirror.cs.wisc.edu/pub/mirrors/ghost/contrib/${P}.tar.gz"

LICENSE="PSTT"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"

RDEPEND="app-text/ghostscript-gpl"

PATCHES=(
	"${FILESDIR}"/${P}-quote-chars-fix.patch
	"${FILESDIR}"/${PV}-flags.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin pstotext
	doman pstotext.1
}
