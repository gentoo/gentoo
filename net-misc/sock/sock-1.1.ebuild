# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/sock/sock-1.1.ebuild,v 1.14 2008/02/04 15:24:11 coldwind Exp $

DESCRIPTION="A shell interface to network sockets"
SRC_URI="ftp://atrey.karlin.mff.cuni.cz/pub/local/mj/net/${P}.tar.gz"
HOMEPAGE="http://atrey.karlin.mff.cuni.cz/~mj/linux.shtml"
KEYWORDS="amd64 sparc x86"
IUSE=""
LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND=""

src_install () {
	dobin sock
	doman sock.1
	dodoc README ChangeLog
}
