# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Netwinder hardware utilities"
HOMEPAGE="http://packages.debian.org/stable/base/nwutil"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* arm"
IUSE=""

DEPEND=""

src_install() {
	make DESTDIR="${D}" install || die "install main failed"
	dodoc ChangeLog README
}
