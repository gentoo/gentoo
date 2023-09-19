# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Validate and fix MPEG audio files"
HOMEPAGE="http://mp3val.sourceforge.net/"
SRC_URI="mirror://sourceforge/mp3val/${P}-src.tar.gz"
S="${WORKDIR}/${P}-src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-open.patch
	"${FILESDIR}"/${P}-makefile.patch
)

src_configure() {
	tc-export CXX
}

src_compile() {
	emake -f Makefile.linux
}

src_install() {
	dobin mp3val

	dodoc changelog.txt
	docinto html
	dodoc manual.html
}
