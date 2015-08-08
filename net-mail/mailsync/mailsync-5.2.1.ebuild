# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A mailbox synchronizer"
HOMEPAGE="http://mailsync.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.orig.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

IUSE=""

DEPEND="virtual/imap-c-client"

src_install() {
	make DESTDIR=${D} install pkgdocdir=/usr/share/doc/${P} || die
	doman doc/mailsync.1
}
