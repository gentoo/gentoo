# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P="${PN}-2003-02-08"
S=${WORKDIR}/${PN}

DESCRIPTION="blinkperl is a telnet server, which plays BlinkenLight movies"
SRC_URI="mirror://sourceforge/blinkserv/${MY_P}.tar.gz"
HOMEPAGE="http://blinkserv.sourceforge.net/"

SLOT="0"
KEYWORDS="~hppa x86"
LICENSE="GPL-2"
IUSE=""
DEPEND=""
RDEPEND="dev-lang/perl dev-perl/Term-ANSIScreen"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}"/${P}-non-local.patch
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_install() {
	make PREFIX=/usr DESTDIR="${D}" install || die

	newinitd "${FILESDIR}"/blinkperl.rc blinkperl
	newconfd "${FILESDIR}"/blinkperl.confd blinkperl
}
