# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

MY_PN=${PN//_/-}
DESCRIPTION="Show hyphenations in DVI files"
HOMEPAGE="http://packages.debian.org/stable/tex/hyphen-show"
SRC_URI="mirror://debian/pool/main/h/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""

S=${WORKDIR}/${MY_PN}-${PV}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PN}-gcc34.patch
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} hyphen_show.c -o hyphen_show || die
}

src_install() {
	dobin hyphen_show || die
	doman hyphen_show.1 || die
	dodoc README.hyphen_show || die
}
