# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature webapp

DESCRIPTION="A customizable PHP script that displays information about your system nicely"
HOMEPAGE="https://phpsysinfo.github.io/phpsysinfo/"
SRC_URI="https://github.com/rk4an/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"
RDEPEND="
	dev-lang/php[simplexml,xml,xsl(+),xslt(+),unicode]
	virtual/httpd-php
"

need_httpd_cgi

src_install() {
	webapp_src_preinst

	dodoc CHANGELOG.md README*
	rm CHANGELOG.md COPYING README* .gitignore || die

	mv phpsysinfo.ini{.new,} || die
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/phpsysinfo.ini

	webapp_src_install
}

pkg_postinst() {
	optfeature "showing disk temperatures." app-admin/hddtemp
	optfeature "showing system uptime." app-misc/uptimed
	optfeature "showing snmp statistics." net-analyzer/net-snmp
	optfeature "showing iptables rules." net-firewall/iptables
	optfeature "showing ipmi sensors." sys-apps/ipmitool
	optfeature "showing ipmi sensors." sys-apps/ipmiutil
	optfeature "showing system sensors." sys-apps/lm-sensors
	optfeature "showing s.m.a.r.t. health." sys-apps/smartmontools
	optfeature "showing lsi raid controller health." sys-block/megactl
	optfeature "showing fake raid statistics." sys-fs/dmraid
	optfeature "showing software raid statistics." sys-fs/mdadm
	optfeature "showing quota information." sys-fs/quota
	optfeature "showing ipmi sensors." sys-libs/freeipmi
	optfeature "showing apc ups statistics." sys-power/apcupsd
	optfeature "showing ups statistics." sys-power/nut
}
