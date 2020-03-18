# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
DEPEND="dev-lang/perl"

DOCS=( README Changes Copyright doc/pista.html )

src_configure() {
	perl Makefile.PL PREFIX=/usr || die "Running Makefile.PL failed"
}
