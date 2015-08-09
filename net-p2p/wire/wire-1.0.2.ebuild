# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Wire is the Wired command line client"
HOMEPAGE="http://www.zankasoftware.com/wired/wire/"
SRC_URI="http://www.zankasoftware.com/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="( >=dev-libs/openssl-0.9.7d )
		( >=sys-libs/readline-4.3 )"

src_install() {
	dobin run/wire || die "dobin failed"
	dodoc INSTALL README
	doman man/wire.1
}
