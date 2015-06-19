# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmcal/libmcal-0.7-r6.ebuild,v 1.1 2013/11/03 20:36:05 robbat2 Exp $

EAPI="5"

inherit eutils multilib

DRIVERS="mcaldrivers-0.9"
SRC_URI_BASE="mirror://sourceforge/libmcal"
DESCRIPTION="Modular Calendar Access Library"
HOMEPAGE="http://mcal.chek.com/"
SRC_URI="${SRC_URI_BASE}/${P}.tar.gz ${SRC_URI_BASE}/${DRIVERS}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="pam"
DOCS="CHANGELOG FAQ-MCAL FEATURE-IMPLEMENTATION HOW-TO-MCAL LICENSE README"

DEPEND="pam? ( virtual/pam )"

S=${WORKDIR}/${PN}

src_prepare() {
	mv "${S}"/../mcal-drivers/* "${S}"/
	einfo "Using /var/spool/calendar instead of /var/calendar"
	for i in FAQ-MCAL HOW-TO-MCAL mstore/mstore.c mstore/README mstore/Changelog; do
		sed -e 's|/var/calendar|/var/spool/calendar|g' -i ${i} || die
	done
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.7-r6-fpic.patch
	epatch "${FILESDIR}"/${PN}-0.7-libdir.patch
	epatch "${FILESDIR}"/${PN}-0.7-r6-gcc4.patch
	epatch "${FILESDIR}"/${PN}-0.7-flexfix.patch
	epatch "${FILESDIR}"/${PN}-0.7-flex-2.5.37.patch
}

src_configure() {
	use pam && export CFLAGS="${CFLAGS} -DUSE_PAM -lpam" LDFLAGS="${LDFLAGS} -lpam"
}

src_compile() {
	einfo "Setting up mstore back-end"
	cd "${S}"/mstore
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -I.." LDFLAGS="${LDFLAGS}"

	einfo "Setting up icap back-end"
	cd "${S}"/icap
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -I.." LDFLAGS="${LDFLAGS}"

	cd "${S}"
	myconf="--with-mstore --with-icap"
	# Sorry repoman, this econf cannot be run until the above two compiles are
	# done.
	econf ${myconf} --libdir=/usr/$(get_libdir)
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ${DOCS}
	newdoc mstore/README mstore-README
	newdoc mstore/Changelog mstore-Changelog
	newdoc icap/Changelog icap-Changelog
	dohtml FUNCTION-REF.html
	keepdir /var/spool/calendar
	fperms 1777 "${ROOT}"/var/spool/calendar
}

pkg_postinst() {
	einfo "You should start adding users to your calendar. ( e.g. htpasswd -c /etc/mpasswd username )"
}
