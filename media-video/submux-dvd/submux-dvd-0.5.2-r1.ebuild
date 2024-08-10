# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A subtitle multiplexer, muxes subtitles into .vob"
HOMEPAGE="http://panteltje.com/panteltje/dvd/"
SRC_URI="http://panteltje.com/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	# just 2 files not worth a makefile patch
	dobin submux-dvd vob2sub
	dodoc CHANGES FORMAT INSTALL README ${P}.lsm spu.html
}
