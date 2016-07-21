# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Small utility for Linux/SPARC that list devices on SBUS"
HOMEPAGE="https://people.redhat.com/tcallawa/lssbus/"
SRC_URI="https://people.redhat.com/tcallawa/lssbus/${P}.tar.gz"

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
