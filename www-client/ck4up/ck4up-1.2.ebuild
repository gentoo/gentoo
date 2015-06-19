# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/ck4up/ck4up-1.2.ebuild,v 1.1 2009/04/18 19:45:04 bangert Exp $

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
