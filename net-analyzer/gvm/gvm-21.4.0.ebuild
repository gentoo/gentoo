# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="Greenbone Vulnerability Management, previously named OpenVAS"
HOMEPAGE="https://www.greenbone.net/en/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="cli +cron +extras +gsa ldap ospd radius"

RDEPEND="
	>=net-analyzer/gvm-libs-${PV}[extras?,ldap?,radius?]
	>=net-analyzer/gvmd-${PV}[extras?]
	>=net-analyzer/openvas-scanner-${PV}[cron?,extras?]
	cli? ( >=net-analyzer/gvm-tools-${PV} )
	gsa? ( >=net-analyzer/greenbone-security-assistant-${PV}[extras?] )
	ospd? ( >=net-analyzer/ospd-openvas-${PV}[extras?] )"

pkg_postinst() {
	optfeature "web server scanning and testing tool" net-analyzer/nikto
	optfeature "port scanner" net-analyzer/nmap
	optfeature "IPsec VPN scanning, fingerprinting and testing tool" net-analyzer/ike-scan
	optfeature "OVALdi — an OVAL Interpreter" app-forensics/ovaldi
	optfeature "Linux-kernel-based portscanner" net-analyzer/portbunny
	optfeature "web application attack and audit framework" net-analyzer/w3af
}
