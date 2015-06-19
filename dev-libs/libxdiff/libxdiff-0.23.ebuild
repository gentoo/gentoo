# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxdiff/libxdiff-0.23.ebuild,v 1.3 2013/03/31 17:50:28 ago Exp $

DESCRIPTION="Library for creating diff files"
HOMEPAGE="http://www.xmailserver.org/xdiff-lib.html"
SRC_URI="http://www.xmailserver.org/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog
}
