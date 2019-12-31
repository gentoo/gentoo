# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-minimal

DESCRIPTION="Name Service Switch module for Multicast DNS"
HOMEPAGE="https://github.com/lathiat/nss-mdns"
SRC_URI="https://github.com/lathiat/nss-mdns/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~mips ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=net-dns/avahi-0.6.31-r2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( >=dev-libs/check-0.11[${MULTILIB_USEDEP}] )"

multilib_src_configure() {
	local myconf=(
		# $(localstatedir)/run/... is used to locate avahi-daemon socket
		--localstatedir=/var

		$(use_enable test tests)
	)

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
}

multilib_src_install_all() {
	dodoc *.md

	insinto /etc
	doins "${FILESDIR}"/mdns.allow
}

pkg_postinst() {
	ewarn "You have to modify your name service switch look up file to enable"
	ewarn "multicast DNS lookups.  If you wish to resolve only IPv6 addresses"
	ewarn "use mdns6.  For IPv4 addresses only, use mdns4.  To resolve both"
	ewarn "use mdns.  Keep in mind that mdns will be slower if there are no"
	ewarn "IPv6 addresses published via mDNS on the network.  There are also"
	ewarn "minimal (mdns?_minimal) libraries which only lookup .local hosts"
	ewarn "and 169.254.x.x addresses."
	ewarn
	ewarn "Add the appropriate mdns into the hosts line in /etc/nsswitch.conf."
	ewarn "An example line looks like:"
	ewarn "hosts:	files mdns4_minimal [NOTFOUND=return] dns mdns4"
	ewarn
	ewarn "If you want to perform mDNS lookups for domains other than the ones"
	ewarn "ending in .local, add them to /etc/mdns.allow."
}
