# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A wordlist generator"
HOMEPAGE="http://sourceforge.net/projects/crunch-wordlist/"
SRC_URI="mirror://sourceforge/crunch-wordlist/crunch-wordlist/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"

src_prepare() {
	epatch_user
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install(){
	dobin crunch
	doman crunch.1
	insinto /usr/share/crunch
	doins charset.lst
}
