# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="command line audio mixer"
HOMEPAGE="http://cmix.sourceforge.net/"
SRC_URI="http://antipoder.dyndns.org/downloads/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
#-amd64: 1.6: 'cmix list' gives: MIXER_READ(SOUND_MIXER_OUTSRC): Input/output error
KEYWORDS="-amd64 ~ppc sparc x86"

PATCHES=( "${FILESDIR}/${P}-ldflags.patch" )

src_configure() {
	tc-export CC
}

src_install() {
	dobin cmix
	einstalldocs
}
