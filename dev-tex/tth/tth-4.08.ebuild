# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Translate TEX into HTML"
HOMEPAGE="http://hutchinson.belmont.ma.us/tth/"
SRC_URI="mirror://sourceforge/${PN}/${PN}${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm ~hppa ppc ppc64 x86"

DEPEND=""
RDEPEND="
	app-text/ghostscript-gpl
	media-libs/netpbm"

S="${WORKDIR}/${PN}"

src_compile() {
	emake GCC="$(tc-getCC) -O" tth
	cd tools || die
	tc-export CC
	echo 'all: tthsplit' > makefile
	emake
}

src_install() {
	dobin tth latex2gif ps2gif tools/ps2png tools/tthsplit
	dodoc CHANGES
	doman tth.1
}
