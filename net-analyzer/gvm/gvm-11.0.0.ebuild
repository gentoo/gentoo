# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="Greenbone Vulnerability Management,previously named OpenVAS"
HOMEPAGE="https://www.greenbone.net/en/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="cli +cron +extras +gsa ldap ospd radius"

RDEPEND="
	>=net-analyzer/gvm-libs-11.0.0[extras?,ldap?,radius?]
	>=net-analyzer/gvmd-9.0.0[extras?]
	>=net-analyzer/openvas-scanner-7.0.0[cron?,extras?]
	cli? ( >=net-analyzer/gvm-tools-2.0.0 )
	gsa? ( >=net-analyzer/greenbone-security-assistant-9.0.0[extras?] )
	ospd? ( >=net-analyzer/ospd-2.0.0[extras?] )"

pkg_postinst() {
	optfeature "web server scanning and testing tool" net-analyzer/nikto
	optfeature "port scanner" net-analyzer/nmap
	optfeature "IPsec VPN scanning, fingerprinting and testing tool" net-analyzer/ike-scan
	optfeature "application protocol detection tool" net-analyzer/amap
	optfeature "OVALdi — an OVAL Interpreter" app-forensics/ovaldi
	optfeature "Linux-kernel-based portscanner" net-analyzer/portbunny
	optfeature "web application attack and audit framework" net-analyzer/w3af
}
