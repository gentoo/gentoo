# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tlsdate/tlsdate-0.0.13.ebuild,v 1.1 2015/07/27 02:59:28 vapier Exp $

EAPI="4"

inherit autotools vcs-snapshot user

DESCRIPTION="Update local time over HTTPS"
HOMEPAGE="https://github.com/ioerror/tlsdate"
SRC_URI="https://github.com/ioerror/tlsdate/tarball/${P} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~x86"
IUSE="dbus +seccomp static-libs"

DEPEND="dev-libs/openssl
	dev-libs/libevent
	dbus? ( sys-apps/dbus )"
RDEPEND="${DEPEND}"

src_prepare() {
	# Use the system cert store rather than a custom one specific
	# to the tlsdate package. #534394
	sed -i \
		-e 's:/tlsdate/ca-roots/tlsdate-ca-roots.conf:/ssl/certs/ca-certificates.crt:' \
		Makefile.am || die

	eautoreconf
}

src_configure() {
	econf \
		--disable-silent-rules \
		$(use_enable dbus) \
		$(use_enable seccomp seccomp-filter) \
		--disable-hardened-checks \
		--without-polarssl \
		--with-unpriv-user=tlsdate \
		--with-unpriv-group=tlsdate
}

src_install() {
	default

	# Use the system cert store; see src_prepare. #446426 #534394
	rm "${ED}"/etc/tlsdate/ca-roots/tlsdate-ca-roots.conf || die
	rmdir "${ED}"/etc/tlsdate/ca-roots || die

	newinitd "${FILESDIR}"/tlsdated.rc tlsdated
	newconfd "${FILESDIR}"/tlsdated.confd tlsdated
	newinitd "${FILESDIR}"/tlsdate.rc tlsdate
	newconfd "${FILESDIR}"/tlsdate.confd tlsdate

	insinto /etc/dbus-1/system.d/
	doins dbus/org.torproject.tlsdate.conf

	use static-libs || \
		find "${ED}"/usr '(' -name '*.la' -o -name '*.a' ')' -delete
}

pkg_preinst() {
	enewgroup tlsdate 124
	enewuser tlsdate 124 -1 /dev/null tlsdate
}
