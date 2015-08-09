# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

S=${WORKDIR}/${PN}

DESCRIPTION="A (semi-)random e-mail signature rotator"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${PV}-1.tar.gz"
HOMEPAGE="http://signify.sf.net/"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="ppc sparc x86 ~amd64"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's/head -1/head -n1/' Makefile
}
src_compile() {
	echo "Perl script!  Woohoo!  No need to compile!"
}

src_install() {
	make PREFIX=${D}/usr/ MANDIR=${D}/usr/share/man install || die
	dodoc COPYING README
	docinto examples
	dodoc examples/{Columned,Complex,Simple,SimpleOrColumned}
}
