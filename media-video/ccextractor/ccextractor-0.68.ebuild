# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Extract closed captioning subtitles from video to SRT"
HOMEPAGE="http://ccextractor.sourceforge.net/"
SRC_URI="mirror://sourceforge/ccextractor/${PN}.src.${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip
	media-libs/libpng
	sys-libs/zlib"

S="${WORKDIR}/${PN}.${PV}"

src_prepare() {
	epatch "${FILESDIR}/${P}-libpng.patch" || die
	rm -r src/libpng src/zlib || die
}

src_compile() {
	cd src
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} -DHAVE_LIBPNG -DGPAC_CONFIG_LINUX -D_FILE_OFFSET_BITS=64 -Igpacmp4/ -o ccextractor $(find . -name '*.cpp') $(find . -name '*.c') -lpng || die
}

src_install() {
	dobin src/ccextractor
	dodoc docs/*.TXT
}
