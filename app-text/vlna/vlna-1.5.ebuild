# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/vlna/vlna-1.5.ebuild,v 1.10 2012/05/09 17:28:12 aballier Exp $

DESCRIPTION="Add nonbreakable spaces after some prepositions in Czech texts"
HOMEPAGE="http://math.feld.cvut.cz/olsak/cstex/"
SRC_URI="ftp://math.feld.cvut.cz/pub/olsak/vlna/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc README README.en ChangeLog vlna.txt || die
	insinto /usr/share/doc/${PF}
	doins vlna.dvi || die
}
