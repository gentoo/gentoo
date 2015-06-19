# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/nss-mdns/nss-mdns-0.10-r2.ebuild,v 1.6 2015/03/02 09:34:35 ago Exp $

EAPI="5"
inherit autotools eutils multilib-minimal

DESCRIPTION="Name Service Switch module for Multicast DNS"
HOMEPAGE="http://0pointer.de/lennart/projects/nss-mdns/"
SRC_URI="http://0pointer.de/lennart/projects/nss-mdns/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~mips ppc x86"
IUSE="search-domains"

RDEPEND=">=net-dns/avahi-0.6.31-r2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
RDEPEND="${RDEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r7
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.10-avahi-socket.patch
	epatch_user
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable search-domains) \
		--enable-avahi
}

multilib_src_install_all() {
	dodoc README

	insinto /etc
	doins "${FILESDIR}"/mdns.allow
}

pkg_postinst() {
	ewarn
	ewarn "You must modify your name service switch look up file to enable"
	ewarn "multicast DNS lookups.  If you wish to resolve only IPv6 addresses"
	ewarn "use mdns6.  For IPv4 addresses only, use mdns4.  To resolve both"
	ewarn "use mdns.  Keep in mind that mdns will be slower if there are no"
	ewarn "IPv6 addresses published via mDNS on the network.  There are also"
	ewarn "minimal (mdns?_minimal) libraries which only lookup .local hosts"
	ewarn "and 169.254.x.x addresses."
	ewarn
	ewarn "Add the appropriate mdns into the hosts line in /etc/nsswitch.conf"
	ewarn "An example line looks like:"
	ewarn "hosts:	files mdns4_minimal [NOTFOUND=return] dns mdns4"
	ewarn
	ewarn "If you want to perform mDNS lookups for domains other than the ones"
	ewarn "ending in .local, add them to /etc/mdns.allow"
	ewarn
}
