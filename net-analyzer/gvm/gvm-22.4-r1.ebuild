# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature systemd

DESCRIPTION="Greenbone Vulnerability Management, previously named OpenVAS"
HOMEPAGE="https://www.greenbone.net"

SLOT="0"
LICENSE="AGPL-3+"
KEYWORDS="amd64 ~x86"
IUSE="cli doc +gsa ldap ospd snmp radius"

RDEPEND="
	>=net-analyzer/gvm-libs-${PV}[doc?,ldap?,radius?]
	>=net-analyzer/gvmd-${PV}[doc?]
	>=net-analyzer/openvas-scanner-${PV}[doc?,snmp?]
	>=net-analyzer/greenbone-feed-sync-23.6.0
	cli? ( >=net-analyzer/gvm-tools-21.10.0 )
	gsa? ( >=net-analyzer/gsad-${PV}[doc?] )
	ospd? ( >=net-analyzer/ospd-openvas-${PV}[doc?] )
"

src_unpack() {
	mkdir "${WORKDIR}/${P}"
}

src_install() {
	systemd_dounit "${FILESDIR}/${PN}.target"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"
}

pkg_postinst() {
	optfeature "web server scanning and testing tool" net-analyzer/nikto
	optfeature "IPsec VPN scanning, fingerprinting and testing tool" net-analyzer/ike-scan
	optfeature "port scanner" net-analyzer/nmap
	optfeature "create results from local security checks" net-analyzer/notus-scanner
}
