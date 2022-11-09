# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Greenbone Vulnerability Management, previously named OpenVAS"
HOMEPAGE="https://www.greenbone.net"

SLOT="0"
LICENSE="AGPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE="cli doc +gsa ldap ospd radius"

RDEPEND="
	>=net-analyzer/gvm-libs-${PV}[doc?,ldap?,radius?]
	>=net-analyzer/gvmd-${PV}[doc?]
	>=net-analyzer/openvas-scanner-${PV}[doc?]
	cli? ( >=net-analyzer/gvm-tools-21.10.0 )
	gsa? ( >=net-analyzer/gsad-${PV}[doc?] )
	ospd? ( >=net-analyzer/ospd-openvas-${PV}[doc?] )
"

pkg_postinst() {
	optfeature "web server scanning and testing tool" net-analyzer/nikto
	optfeature "port scanner" net-analyzer/nmap
	optfeature "IPsec VPN scanning, fingerprinting and testing tool" net-analyzer/ike-scan
	optfeature "OVALdi — an OVAL Interpreter" app-forensics/ovaldi
}
