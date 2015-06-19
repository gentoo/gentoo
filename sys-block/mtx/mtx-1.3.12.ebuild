# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/mtx/mtx-1.3.12.ebuild,v 1.6 2009/12/28 18:20:53 armin76 Exp $

DESCRIPTION="Utilities for controlling SCSI media changers and tape drives"
HOMEPAGE="http://mtx.sourceforge.net/"
SRC_URI="mirror://sourceforge/mtx/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""

src_install () {
	einstall || die
	dodoc CHANGES COMPATABILITY FAQ README TODO
	dohtml mtxl.README.html
}
