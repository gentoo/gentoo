# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit perl-module systemd

DESCRIPTION="Hardware and software inventory tool (client)"
HOMEPAGE="http://www.ocsinventory-ng.org https://github.com/OCSInventory-NG/UnixAgent"
SRC_URI="https://github.com/OCSInventory-NG/UnixAgent/releases/download/v${PV}/Ocsinventory-Unix-Agent-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-perl/Crypt-SSLeay
	dev-perl/Net-IP
	dev-perl/Net-SNMP
	dev-perl/Net-SSLeay
	dev-perl/Proc-Daemon
	dev-perl/XML-NamespaceSupport
	dev-perl/XML-SAX
	dev-perl/XML-Simple
	dev-perl/libwww-perl
	sys-apps/dmidecode
	sys-apps/pciutils
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/Ocsinventory-Unix-Agent-${PV}"

src_compile() {
	perl-module_src_compile
	rm run-postinst || die
}

src_install() {
	perl-module_src_install

	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"

	insinto /etc/ocsinventory
	doins "${FILESDIR}/${PN}.cfg"
	doins "${FILESDIR}/modules.conf"

	insinto /etc/cron.d
	newins "${FILESDIR}/${PN}.crond" ${PN}
	systemd_dounit "${FILESDIR}/${PN}".{service,timer}

	insinto /etc/logrotate.d
	doins "contrib/cron/${PN}.logrotate"
}
