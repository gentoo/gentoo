# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3_check/mp3_check-1.98.ebuild,v 1.16 2009/08/03 12:53:03 ssuominen Exp $

inherit eutils toolchain-funcs

DESCRIPTION="MP3 consistency checker"
HOMEPAGE="http://sourceforge.net/projects/mp3check/"
SRC_URI="mirror://sourceforge/mp3check/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install () {
	dobin mp3_check || die "dobin failed"
	dodoc WISHLIST TODO THANKYOU README *NOTES FOR_TESTING GOALS MILESTONE*
}
