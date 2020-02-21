# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils user

MY_P="PTlink.OPM${PV}"

DESCRIPTION="PTlink Open Proxy Monitor"
HOMEPAGE="http://www.ptlink.net/"
SRC_URI="ftp://ftp.sunsite.dk/projects/ptlink/ptopm/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND=">=sys-apps/sed-4"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		--sysconfdir=/etc/ptlink-opm \
		--localstatedir=/var/lib/ptlink-opm
}

src_install() {
	newbin src/ptopm ptlink-opm

	insinto /etc/ptlink-opm
	newins samples/ptopm.dconf.sample ptopm.dconf
	doins samples/scan_rules.dconf

	keepdir /var/{lib,log}/ptlink-opm
	dosym /var/log/ptlink-opm /var/lib/ptlink-opm/log

	dodoc CHANGES README

	newinitd "${FILESDIR}"/ptlink-opm.init.d ptlink-opm
	newconfd "${FILESDIR}"/ptlink-opm.conf.d ptlink-opm
}

pkg_postinst() {
	enewuser ptlink-opm
	chown ptlink-opm "${ROOT}"/var/{log,lib}/ptlink-opm
}
