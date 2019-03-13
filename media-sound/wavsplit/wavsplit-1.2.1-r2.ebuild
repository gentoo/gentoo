# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Simple command line tool to split WAV files"
HOMEPAGE="https://sourceforge.net/projects/wavsplit/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#-sparc, -amd64: 1.0: "Only supports PCM wave format" error message.
KEYWORDS="amd64 -sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-large-files.patch
	"${FILESDIR}"/${P}-64bit.patch
)

src_prepare() {
	default
	emake clean
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_test() { :; } #294302

src_install() {
	dobin wav{ren,split}
	doman wav{ren,split}.1
	dodoc BUGS CHANGES CREDITS README{,.wavren}
}
