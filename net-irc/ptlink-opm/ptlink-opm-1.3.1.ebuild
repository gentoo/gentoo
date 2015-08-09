# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils user

MY_P="PTlink.OPM${PV}"

DESCRIPTION="PTlink Open Proxy Monitor"
HOMEPAGE="http://www.ptlink.net/"
SRC_URI="ftp://ftp.sunsite.dk/projects/ptlink/ptopm/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND=""
DEPEND=">=sys-apps/sed-4"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf \
		--sysconfdir=/etc/ptlink-opm \
		--localstatedir=/var/lib/ptlink-opm \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	newbin src/ptopm ptlink-opm || die "newbin failed"

	insinto /etc/ptlink-opm
	newins samples/ptopm.dconf.sample ptopm.dconf || die "newins failed"
	doins samples/scan_rules.dconf || die "doins failed"

	keepdir /var/{lib,log}/ptlink-opm || die "keepdir failed"
	dosym /var/log/ptlink-opm /var/lib/ptlink-opm/log || die "dosym failed"

	dodoc CHANGES README || die "dodoc failed"

	newinitd ${FILESDIR}/ptlink-opm.init.d ptlink-opm || die "newinitd failed"
	newconfd ${FILESDIR}/ptlink-opm.conf.d ptlink-opm || die "newconfd failed"
}

pkg_postinst() {
	enewuser ptlink-opm
	chown ptlink-opm ${ROOT}/var/{log,lib}/ptlink-opm
}
