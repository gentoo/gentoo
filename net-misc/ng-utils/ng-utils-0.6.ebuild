# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ng-utils/ng-utils-0.6.ebuild,v 1.1 2008/02/03 11:29:38 stefaan Exp $

DESCRIPTION="A collection of small tools for accessing netgroup contents"
HOMEPAGE="ftp://ftp.hungry.com/pub/hungry/ng-utils"
SRC_URI="ftp://ftp.hungry.com/pub/hungry/ng-utils/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
