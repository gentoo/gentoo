# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
