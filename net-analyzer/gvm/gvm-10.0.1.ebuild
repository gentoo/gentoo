# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="Greenbone Vulnerability Management,previously named OpenVAS"
HOMEPAGE="https://www.greenbone.net/en/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="cli +cron +extras +gsa ldap ospd postgres radius +sqlite"
REQUIRED_USE="|| ( postgres sqlite )"

RDEPEND="
	>=net-analyzer/gvm-libs-10.0.1[extras?,ldap?,radius?]
	>=net-analyzer/gvmd-8.0.1[extras?,postgres?,sqlite?]
	>=net-analyzer/openvas-scanner-6.0.1[cron?,extras?]
	cli? ( >=net-analyzer/gvm-tools-2.0.0 )
	gsa? ( >=net-analyzer/greenbone-security-assistant-8.0.1[extras?] )
	ospd? ( >=net-analyzer/ospd-2.0.0[extras?] )"

pkg_postinst() {
	elog "Additional support for extra checks can be get from"
	optfeature "Web server scanning and testing tool" net-analyzer/nikto
	optfeature "Portscanner" net-analyzer/nmap
	optfeature "IPsec VPN scanning, fingerprinting and testing tool" net-analyzer/ike-scan
	optfeature "Application protocol detection tool" net-analyzer/amap
	optfeature "ovaldi (OVAL) — an OVAL Interpreter" app-forensics/ovaldi
	optfeature "Linux-kernel-based portscanner" net-analyzer/portbunny
	optfeature "Web application attack and audit framework" net-analyzer/w3af
}
