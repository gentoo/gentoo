# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tlsdate/tlsdate-0.0.11.ebuild,v 1.1 2014/10/25 06:24:29 vapier Exp $

EAPI="4"

inherit autotools vcs-snapshot user

DESCRIPTION="Update local time over HTTPS"
HOMEPAGE="https://github.com/ioerror/tlsdate"
SRC_URI="https://github.com/ioerror/tlsdate/tarball/${P} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="dbus +seccomp static-libs"

DEPEND="dev-libs/openssl
	dbus? ( sys-apps/dbus )"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable dbus) \
		$(use_enable seccomp seccomp-filter) \
		--disable-hardened-checks \
		--with-unpriv-user=tlsdate \
		--with-unpriv-group=tlsdate
}

src_install() {
	default

	# Use Google servers by default rather than a random German site.
	# They provide round robin DNS and local servers automatically.
	rm "${ED}"/etc/tlsdate/ca-roots/tlsdate-ca-roots.conf || die #446426
	dosym "${EPREFIX}"/etc/ssl/certs/Equifax_Secure_CA.pem \
		/etc/tlsdate/ca-roots/tlsdate-ca-roots.conf
	sed -i \
		-e 's:www.ptb.de:www.google.com:' \
		"${ED}"/etc/tlsdate/tlsdated.conf || die

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
