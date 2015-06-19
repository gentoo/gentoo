# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tlsdate/tlsdate-0.0.4-r2.ebuild,v 1.2 2014/01/08 06:31:38 vapier Exp $

EAPI="4"

inherit autotools vcs-snapshot eutils user

DESCRIPTION="Update local time over HTTPS"
HOMEPAGE="https://github.com/ioerror/tlsdate"
SRC_URI="https://github.com/ioerror/tlsdate/tarball/${P} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs"

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-compiler-flags.patch
	epatch "${FILESDIR}"/${P}-configure-user-group.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-hardened-checks \
		--with-unpriv-user=tlsdate \
		--with-unpriv-group=tlsdate
}

src_install() {
	default
	rm -r "${ED}"/etc || die #446426
	newinitd "${FILESDIR}"/tlsdated.rc tlsdated
	newconfd "${FILESDIR}"/tlsdated.confd tlsdated
	newinitd "${FILESDIR}"/tlsdate.rc tlsdate
	newconfd "${FILESDIR}"/tlsdate.confd tlsdate
	use static-libs || \
		find "${ED}"/usr '(' -name '*.la' -o -name '*.a' ')' -delete
}

pkg_preinst() {
	enewgroup tlsdate 124
	enewuser tlsdate 124 -1 /dev/null tlsdate
}
