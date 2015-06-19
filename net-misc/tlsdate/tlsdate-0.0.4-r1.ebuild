# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tlsdate/tlsdate-0.0.4-r1.ebuild,v 1.1 2012/12/11 01:49:23 vapier Exp $

EAPI="4"

inherit autotools vcs-snapshot flag-o-matic

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
	sed -i -r '/^[[:space:]]AX_(APPEND_COMPILE_FLAGS|CHECK_LINK_FLAG)[(]/d' configure.ac || die
	eautoreconf
	append-cppflags "-DUNPRIV_GROUP='\"nobody\"'"
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
