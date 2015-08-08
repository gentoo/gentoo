# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_P="${P/-/_}"

DESCRIPTION="SNMP Trap Translator"
SRC_URI="mirror://sourceforge/snmptt/${MY_P}.tgz"
HOMEPAGE="http://www.snmptt.org/"

LICENSE="GPL-2"

KEYWORDS="~amd64 ~ppc x86"
SLOT="0"
IUSE="mysql postgres"

S="${WORKDIR}/${MY_P}"

RDEPEND=">=dev-lang/perl-5.6.1
	dev-perl/Config-IniFiles
	>=net-analyzer/net-snmp-5.1
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# bug 105354, daemonize this thing
	sed -i -e "s:mode = standalone:mode = daemon:g" snmptt.ini || die

	echo "traphandle default /usr/sbin/snmptt" >examples/snmptrapd.conf.sample
}

src_install() {
	into /usr
	dosbin snmptt
	dosbin snmptthandler
	dosbin snmptt-net-snmp-test
	dosbin snmpttconvert
	dosbin snmpttconvertmib

	insinto /etc/snmp
	doins snmptt.ini
	doins examples/snmptt.conf.generic
	cp -pPR ${D}/etc/snmp/snmptt.conf.generic ${D}/etc/snmp/snmptt.conf
	doins examples/snmptrapd.conf.sample

	dodoc BUGS ChangeLog README sample-trap
	dohtml docs/faqs.html docs/index.html docs/layout1.css docs/snmptt.html docs/snmpttconvert.html docs/snmpttconvertmib.html

	newinitd "${FILESDIR}"/snmptt.initd snmptt
}

pkg_postinst() {
	if ( use mysql || use postgres ); then
		elog "Read the html documentation to configure your database."
	fi
	elog "Please configure /etc/snmp/snmptt.conf before running."
}
