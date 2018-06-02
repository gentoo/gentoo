# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="sync up 2 audio ch. and/or combine 2 mono audio ch. into one stereo wave ch"
HOMEPAGE="http://panteltje.com/panteltje/dvd/"
SRC_URI="http://panteltje.com/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS=( CHANGES README combine_wave.man )

PATCHES=( "${FILESDIR}/${P}-overflow.patch" )

src_prepare() {
	default
	# fix makefile
	sed -i -e "s:gcc:\$(CC):g" -e "s:= -O2:+=:g" \
		-e "s:\( -o \): \$(LDFLAGS)\1:g" Makefile || die "sed Makefile failed"
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin combine_wave
	einstalldocs
}
