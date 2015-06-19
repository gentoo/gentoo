# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/crunch/crunch-3.4.ebuild,v 1.1 2013/11/24 12:39:18 pinkbyte Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A wordlist generator"
HOMEPAGE="http://sourceforge.net/projects/crunch-wordlist/"
SRC_URI="mirror://sourceforge/crunch-wordlist/crunch-wordlist/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"

src_prepare() {
	tc-export CC
	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch_user
}

src_install(){
	dobin crunch
	doman crunch.1
	insinto /usr/share/crunch
	doins charset.lst
}
