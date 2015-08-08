# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Extract closed captioning subtitles from video to SRT"
HOMEPAGE="http://ccextractor.sourceforge.net/"
SRC_URI="mirror://sourceforge/ccextractor/${P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_compile() {
	cd src
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} -D_FILE_OFFSET_BITS=64 -o ccextractor *.cpp || die
}

src_install() {
	dobin src/ccextractor
	dodoc docs/*.TXT
}
