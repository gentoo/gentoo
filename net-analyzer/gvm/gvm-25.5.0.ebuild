# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature systemd

DESCRIPTION="Greenbone Vulnerability Management, previously named OpenVAS"
HOMEPAGE="https://www.greenbone.net"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE="cli doc +gsa ldap ospd snmp radius"

RDEPEND="
	>=net-analyzer/gvm-libs-22.22.0[doc?,ldap?,radius?]
	>=net-analyzer/gvmd-26.0.0[doc?]
	>=net-analyzer/openvas-scanner-23.20.1[doc?,snmp?]
	>=net-analyzer/greenbone-feed-sync-23.6.0
	cli? ( >=net-analyzer/gvm-tools-25.3.0 )
	gsa? (
		>=net-analyzer/gsad-24.3.0[doc?]
		>=net-analyzer/gsa-25.0.0
	)
	ospd? ( >=net-analyzer/ospd-openvas-22.9.0[doc?] )
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
	optfeature "command line tool to scan for alive hosts" net-analyzer/boreas
}
