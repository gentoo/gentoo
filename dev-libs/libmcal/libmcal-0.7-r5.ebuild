# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmcal/libmcal-0.7-r5.ebuild,v 1.15 2011/02/06 12:37:55 leio Exp $

inherit eutils multilib

DRIVERS="mcaldrivers-0.9"
SRC_URI_BASE="mirror://sourceforge/libmcal"
DESCRIPTION="Modular Calendar Access Library"
HOMEPAGE="http://mcal.chek.com/"
SRC_URI="${SRC_URI_BASE}/${P}.tar.gz ${SRC_URI_BASE}/${DRIVERS}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="pam"

DEPEND="pam? ( virtual/pam )"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}
	mv ${S}/../mcal-drivers/* ${S}/
	einfo "Using /var/spool/calendar instead of /var/calendar"
	for i in FAQ-MCAL HOW-TO-MCAL mstore/mstore.c mstore/README mstore/Changelog; do
		sed -e 's|/var/calendar|/var/spool/calendar|g' -i ${i}
	done
	cd ${S}
	epatch ${FILESDIR}/${P}-fpic.patch
	epatch ${FILESDIR}/${P}-libdir.patch
	epatch ${FILESDIR}/${P}-gcc4.patch
	epatch ${FILESDIR}/${P}-flexfix.patch
}

src_compile() {
	use pam && CFLAGS="${CFLAGS} -DUSE_PAM -lpam" LDFLAGS="${LDFLAGS} -lpam"
	einfo "Setting up mstore back-end"
	cd ${S}/mstore
	emake CFLAGS="${CFLAGS} -I.." LDFLAGS="${LDFLAGS}" || die

	einfo "Setting up icap back-end"
	cd ${S}/icap
	emake CFLAGS="${CFLAGS} -I.." LDFLAGS="${LDFLAGS}" || die

	cd ${S}
	myconf="--with-mstore --with-icap"
	econf ${myconf} --libdir=/usr/$(get_libdir) || die
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc CHANGELOG FAQ-MCAL FEATURE-IMPLEMENTATION HOW-TO-MCAL LICENSE README
	newdoc mstore/README mstore-README
	newdoc mstore/Changelog mstore-Changelog
	newdoc icap/Changelog icap-Changelog
	dohtml FUNCTION-REF.html
	keepdir /var/spool/calendar
	fperms 1777 /var/spool/calendar
}

pkg_postinst() {
	einfo "You should start adding users to your calendar. ( e.g. htpasswd -c /etc/mpasswd username )"
	# enforce perms
	chmod 1777 ${ROOT}/var/spool/calendar
}
