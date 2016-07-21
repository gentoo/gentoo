# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

IUSE=""

DESCRIPTION="command line audio mixer"
HOMEPAGE="http://cmix.sourceforge.net/"
SRC_URI="http://antipoder.dyndns.org/downloads/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
#-amd64: 1.6: 'cmix list' gives: MIXER_READ(SOUND_MIXER_OUTSRC): Input/output error
KEYWORDS="-amd64 ~ppc sparc x86"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-ldflags.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	einstall || die
	dobin cmix
	dodoc README || die
}
