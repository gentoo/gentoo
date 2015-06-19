# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/openvpn-blacklist/openvpn-blacklist-0.3.ebuild,v 1.1 2008/06/19 15:26:37 hanno Exp $

DESCRIPTION="Detection of weak openvpn keys produced by certain debian versions between 2006 and 2008"
HOMEPAGE="http://packages.debian.org/sid/openvpn-blacklist"
SRC_URI="mirror://debian/pool/main/o/${PN}/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="dev-lang/python"
S="${WORKDIR}/${P}"

src_compile() {
	einfo nothing to compile
}

src_install() {
	dobin openvpn-vulnkey || die "dobin failed"
	doman openvpn-vulnkey.1 || die "doman failed"
	dodir /usr/share/openvpn-blacklist/
	cat "${S}/debian/blacklist.prefix" > "${D}/usr/share/openssl-blacklist/blacklist.RSA-2048"
	cat "${S}/blacklist.RSA-2048" | cut -d ' ' -f 2 | cut -b13- | sort \
		>> "${D}/usr/share/openvpn-blacklist/blacklist.RSA-2048"
}
