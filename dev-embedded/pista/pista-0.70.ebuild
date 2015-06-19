# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/pista/pista-0.70.ebuild,v 1.3 2012/10/29 08:53:08 ago Exp $

DESCRIPTION="Commandline-driven interface to PICSTART+ PIC programmer"
HOMEPAGE="http://gatling.ikk.sztaki.hu/~kissg/pd/pista/pista.html"
SRC_URI="ftp://gatling.ikk.sztaki.hu/pub/pic/pista/${P}.tar.gz
	http://pista.choup.net/pub/pic/pista/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/TermReadKey"

src_compile() {
	perl Makefile.PL PREFIX=/usr || die "Running Makefile.PL failed"
	emake || die "make failed"
}

src_install() {
	emake install DESTDIR=${D} || die
	dodoc README Changes Copyright doc/pista.html
}
