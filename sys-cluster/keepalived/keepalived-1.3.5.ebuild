# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A strong & robust keepalive facility to the Linux Virtual Server project"
HOMEPAGE="http://www.keepalived.org/"
SRC_URI="http://www.keepalived.org/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="dbus debug ipv6 snmp"

RDEPEND="dev-libs/libnl:=
	dev-libs/openssl:=
	dev-libs/popt
	net-libs/libnfnetlink
	sys-apps/iproute2
	dbus? ( sys-apps/dbus )
	snmp? ( net-analyzer/net-snmp )"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-4.4"

DOCS=( README CONTRIBUTORS INSTALL ChangeLog AUTHOR TODO
	doc/keepalived.conf.SYNOPSIS doc/NOTE_vrrp_vmac.txt )

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	STRIP=/bin/true \
	econf \
		--with-kernel-dir=/usr \
		--enable-sha1 \
		--enable-vrrp \
		$(use_enable dbus) \
		$(use_enable dbus dbus-create-instance) \
		$(use_enable debug) \
		$(use_enable snmp)
}

src_install() {
	default

	newinitd "${FILESDIR}"/keepalived.init keepalived
	newconfd "${FILESDIR}"/keepalived.confd keepalived

	use snmp && dodoc doc/KEEPALIVED-MIB

	docinto genhash
	dodoc genhash/README genhash/AUTHOR genhash/ChangeLog
	# This was badly named by upstream, it's more HOWTO than anything else.
	newdoc INSTALL INSTALL+HOWTO

	# Security risk to bundle SSL certs
	rm -f "${ED}"/etc/keepalived/samples/*.pem
	# Clean up sysvinit files
	rm -rf "${ED}"/etc/sysconfig "${ED}"/etc/rc.d/
}
