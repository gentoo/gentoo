# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/watchpid/watchpid-0.1-r1.ebuild,v 1.3 2009/09/23 21:07:33 patrick Exp $

DESCRIPTION="Watches a process for termination"
SRC_URI="mirror://gentoo/${PN}_${PV}.tar.gz"
HOMEPAGE="http://www.codepark.org/"
KEYWORDS="x86 amd64 -ppc"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
DEPEND=""

src_compile() {
	econf || die "econf failed"
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc README AUTHORS
}
