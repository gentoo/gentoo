# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/nss-db/nss-db-2.2-r1.ebuild,v 1.20 2012/05/03 19:52:55 robbat2 Exp $

inherit libtool eutils

DESCRIPTION="Allows important system files to be stored in a fast database file rather than plain text"
HOMEPAGE="http://www.gnu.org/"
SRC_URI="mirror://gnu/glibc/nss_db-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="x86 -ppc"

RDEPEND=">=sys-libs/db-3.2.3-r1"
DEPEND="${RDEPEND}
	sys-devel/gettext
	!>=sys-libs/glibc-2.3"
IUSE=""

S=${WORKDIR}/nss_db-${PV}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/db3.patch
	autoconf
}

src_compile() {
	elibtoolize
	./configure --with-db=/usr/include/db3 --prefix=/usr --libdir=/usr/lib || die
	make ${MAKEOPTS} || die
}

src_install() {
	make DESTDIR=${D} install

	rm -rf ${D}/usr/lib
	cd ${D}/lib
	ln -s libnss_db-${PV}.so libnss_db.so

	cd ${S}
	dodoc AUTHORS COPYING* ChangeLog NEWS README THANKS
}
