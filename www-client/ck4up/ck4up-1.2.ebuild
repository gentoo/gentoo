# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Check for Updates on HTTP pages"
HOMEPAGE="http://jue.li/crux/ck4up/"
SRC_URI="http://jue.li/crux/ck4up/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/ruby"

src_compile() {
	return
}

src_install() {
	doman ck4up.1
	newbin ck4up.rb ck4up
	dodoc ChangeLog || die
}
