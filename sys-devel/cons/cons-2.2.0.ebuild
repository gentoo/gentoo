# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/cons/cons-2.2.0.ebuild,v 1.15 2010/06/23 12:06:50 jlec Exp $

DESCRIPTION="Extensible perl-based build utility"
SRC_URI="http://www.dsmit.com/cons/stable/${P}.tgz"
HOMEPAGE="http://www.dsmit.com/cons/"

SLOT="2.2"
LICENSE="GPL-2"
KEYWORDS="alpha ~amd64 ppc ~sparc x86"
IUSE=""

DEPEND="
	dev-lang/perl
	virtual/perl-Digest-MD5"
RDEPEND="
	${DEPEND}
	!sci-biology/emboss"

src_install() {
	dobin cons || die
	dodoc CHANGES INSTALL MANIFEST README RELEASE TODO || die
	dohtml *.html || die
	doman cons.1.gz || die
}
