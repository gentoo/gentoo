# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools vcs-snapshot eutils user

DESCRIPTION="Update local time over HTTPS"
HOMEPAGE="https://github.com/ioerror/tlsdate"
SRC_URI="https://github.com/ioerror/tlsdate/tarball/${P} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="dbus static-libs"

DEPEND="dev-libs/openssl
	dbus? ( sys-apps/dbus )"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable dbus) \
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
