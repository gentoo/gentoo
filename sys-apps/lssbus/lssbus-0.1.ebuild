# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lssbus/lssbus-0.1.ebuild,v 1.2 2006/12/01 18:53:59 gustavoz Exp $

DESCRIPTION="Small utility for Linux/SPARC that list devices on SBUS"
HOMEPAGE="http://people.redhat.com/tcallawa/lssbus/"
SRC_URI="http://people.redhat.com/tcallawa/lssbus/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* sparc"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dosbin lssbus
	dodoc COPYING README
}
