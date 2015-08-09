# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="PAM interface to bioapi package"
HOMEPAGE="http://code.google.com/p/pam-bioapi/"
SRC_URI="http://pam-bioapi.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="sys-auth/bioapi
	sys-libs/pam
	dev-db/sqlite"
RDEPEND="${DEPEND}
	sys-auth/tfm-fingerprint"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-headers.patch #241322
	sed -i \
		-e 's/-version-info 0:4:0/-avoid-version/' \
		libpam_bioapi/Makefile.in #261598
	sed -i \
		-e 's:@prefix@::' \
		-e '/pam_unix.so/s:.*:auth include system-auth:' \
		etc/pam.d/{bioapi_chbird,test-pam_bioapi}.in #261598
}

src_compile() {
	econf --sbindir=/sbin || die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README TODO

	dodir /$(get_libdir)
	mv "${D}"/usr/$(get_libdir)/security "${D}"/$(get_libdir)/ || die
	rm -f "${D}"/$(get_libdir)/security/*.la
}
