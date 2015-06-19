# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ddir/ddir-0_p20100323.ebuild,v 1.2 2010/03/27 16:17:35 ssuominen Exp $

DESCRIPTION="A perl implementation of the tree(1) program"
HOMEPAGE="http://freshmeat.net/projects/ddir"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl"

src_compile() { :; }

src_install() {
	newbin bin/ddir.pl ddir || die
	doman bin/ddir.1
	dodoc ChangeLog doc/manual/*.txt README
	dohtml doc/manual/*.html
}
