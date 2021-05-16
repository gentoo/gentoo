# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SNMP Trap Translator"
SRC_URI="mirror://sourceforge/snmptt/${P/-/_}.tgz"
HOMEPAGE="http://www.snmptt.org/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~ppc x86"
SLOT="0"

S="${WORKDIR}/${P/-/_}"

RDEPEND="
	dev-lang/perl
	dev-perl/Config-IniFiles
	net-analyzer/net-snmp
"

src_prepare() {
	default

	# bug 105354, daemonize by default
	sed -i \
		-e 's:mode = standalone:mode = daemon:g' \
		-e '/pid_file/s:/var/run:/run:g' \
		snmptt.ini || die

	echo "traphandle default /usr/sbin/snmptt" > examples/snmptrapd.conf.sample || die
}

src_install() {
	into /usr
	dosbin \
		snmptt \
		snmptt-net-snmp-test \
		snmpttconvert \
		snmpttconvertmib \
		snmptthandler \
		snmptthandler-embedded

	insinto /etc/snmp
	doins \
		examples/snmptrapd.conf.sample \
		examples/snmptt.conf.generic \
		snmptt.ini
	newins examples/snmptt.conf.generic snmptt.conf

	dodoc ChangeLog README sample-trap

	docinto html
	dodoc docs/*

	newinitd "${FILESDIR}"/snmptt.initd-r1 snmptt

	insinto /etc/logrotate.d
	newins snmptt.logrotate snmptt
}
