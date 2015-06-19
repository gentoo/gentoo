# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/substract_wave/substract_wave-0.3-r1.ebuild,v 1.1 2011/04/26 13:02:50 angelos Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="substracts 2 mono wave files from each other by a factor specified on the command line"
HOMEPAGE="http://panteltje.com/panteltje/dvd/"
SRC_URI="http://panteltje.com/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch \
		"${FILESDIR}"/${P}-overflow.patch
}

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CHANGES mono-stereo.txt README
}
