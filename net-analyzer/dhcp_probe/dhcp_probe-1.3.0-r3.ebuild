# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils flag-o-matic

DESCRIPTION="dhcp_probe attempts to discover DHCP and BootP servers on a directly-attached Ethernet network"
HOMEPAGE="http://www.net.princeton.edu/software/dhcp_probe/"
SRC_URI="http://www.net.princeton.edu/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	net-libs/libpcap
	>=net-libs/libnet-1.1.2.1-r2
	"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}/*.patch
}

src_configure() {
	use amd64 && append-flags -D__ARCH__=64
	STRIP=true econf || die "econf failed"
}

src_install() {
	emake install DESTDIR="${D}"

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	dodoc \
		extras/dhcp_probe.cf.sample \
		NEWS \
		README \
		ChangeLog \
		AUTHORS \
		TODO \
		|| die "dodoc failed"
}
