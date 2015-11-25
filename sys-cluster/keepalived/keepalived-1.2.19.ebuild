# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="A strong & robust keepalive facility to the Linux Virtual Server project"
HOMEPAGE="http://www.keepalived.org/"
SRC_URI="http://www.keepalived.org/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="debug ipv6 snmp"

RDEPEND="dev-libs/popt
	sys-apps/iproute2
	dev-libs/libnl:=
	dev-libs/openssl:=
	snmp? ( net-analyzer/net-snmp )"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.30"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.2-libipvs-fix-backup-daemon.patch
)

DOCS=( README CONTRIBUTORS INSTALL VERSION ChangeLog AUTHOR TODO
	doc/keepalived.conf.SYNOPSIS doc/NOTE_vrrp_vmac.txt )

src_prepare() {
	eautoreconf
}

src_configure() {
	STRIP=/bin/true \
	econf \
		--with-kernel-dir=/usr \
		--enable-vrrp \
		$(use_enable debug) \
		$(use_enable snmp)
}

src_install() {
	default

	newinitd "${FILESDIR}"/keepalived.init keepalived
	newconfd "${FILESDIR}"/keepalived.confd keepalived

	use snmp && dodoc doc/KEEPALIVED-MIB

	docinto genhash
	dodoc genhash/README genhash/AUTHOR genhash/ChangeLog genhash/VERSION
	# This was badly named by upstream, it's more HOWTO than anything else.
	newdoc INSTALL INSTALL+HOWTO

	# Security risk to bundle SSL certs
	rm -f "${ED}"/etc/keepalived/samples/*.pem
	# Clean up sysvinit files
	rm -rf "${ED}"/etc/sysconfig "${ED}"/etc/rc.d/
}
