# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/linklint/linklint-2.3.5.ebuild,v 1.8 2015/03/21 16:35:47 jlec Exp $

EAPI=5

DESCRIPTION="A Perl program that checks links on web sites"
HOMEPAGE="http://www.linklint.org/"
SRC_URI="http://www.linklint.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl"

src_install() {
	newbin ${P} ${PN}
	dodoc INSTALL.unix INSTALL.windows READ_ME.txt CHANGES.txt
	dohtml -r doc/*
}
