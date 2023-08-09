# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="sync up 2 audio ch. and/or combine 2 mono audio ch. into one stereo wave ch"
HOMEPAGE="https://www.panteltje.nl/panteltje/dvd/index.html"
SRC_URI="https://www.panteltje.nl/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-overflow.patch
	"${FILESDIR}"/${P}-missing-includes.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin combine_wave

	einstalldocs
	dodoc combine_wave.man
}
