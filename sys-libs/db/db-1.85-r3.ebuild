# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/db/db-1.85-r3.ebuild,v 1.18 2014/01/18 04:14:32 vapier Exp $

inherit eutils toolchain-funcs multilib multilib

DESCRIPTION="old berk db kept around for really old packages"
HOMEPAGE="http://www.oracle.com/technology/software/products/berkeley-db/db/index.html"
SRC_URI="http://download.oracle.com/berkeley-db/db.${PV}.tar.gz
		 mirror://gentoo/${PF}.1.patch.bz2"
# The patch used by Gentoo is from Fedora, and includes all 5 patches found on
# the Oracle page, plus others.

LICENSE="Sleepycat"
SLOT="1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/db.${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${PF}.1.patch
	epatch "${FILESDIR}"/${P}-gentoo-paths.patch
	sed -i \
		-e "s:@GENTOO_LIBDIR@:$(get_libdir):" \
		PORT/linux/Makefile || die
}

src_compile() {
	tc-export CC AR RANLIB
	emake -C PORT/linux OORG="${CFLAGS}" || die
}

src_install() {
	make -C PORT/linux install DESTDIR="${D}" || die

	# binary compat symlink
	dosym libdb1.so.2 /usr/$(get_libdir)/libdb.so.2 || die

	dosed "s:<db.h>:<db1/db.h>:" /usr/include/db1/ndbm.h
	dosym db1/ndbm.h /usr/include/ndbm.h

	dodoc changelog README
	newdoc hash/README README.hash
	docinto ps
	dodoc docs/*.ps
}
