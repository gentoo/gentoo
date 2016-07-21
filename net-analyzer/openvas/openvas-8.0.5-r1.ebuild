# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit readme.gentoo

DESCRIPTION="A remote security scanner"
HOMEPAGE="http://www.openvas.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+pdf"

RDEPEND="
	dev-db/redis
	>=net-analyzer/openvas-libraries-8.0.5
	>=net-analyzer/openvas-scanner-5.0.4
	>=net-analyzer/openvas-manager-6.0.6
	>=net-analyzer/openvas-cli-1.4.3
	net-analyzer/openvas-tools
	pdf? (
		app-text/htmldoc
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)"

S="${WORKDIR}"

pkg_postinst() {
	elog "Additional support for extra checks can be get from"
	optfeature "Nikto — a web server scanning and testing tool" net-analyzer/nikto
	optfeature "NMAP — a portscanner" net-analyzer/nmap
	optfeature "ike-scan - an IPsec VPN scanning, fingerprinting and testing tool" net-analyzer/ike-scan
	optfeature "amap — an application protocol detection tool" net-analyzer/amap
	optfeature "ldapsearch from OpenLDAP utilities — retrieves information from LDAP dictionaries" net-nds/openldap
	optfeature "ovaldi (OVAL) — an OVAL Interpreter" app-forensics/ovaldi
	optfeature "portbunny — a Linux-kernel-based portscanner" net-analyzer/portbunny
	optfeature "w3af — a web application attack and audit framework" net-analyzer/w3af
	optfeature "The Greenbone Security Assistant as alternative to the plain scanner" net-analyzer/greebone-security-assistant
}
