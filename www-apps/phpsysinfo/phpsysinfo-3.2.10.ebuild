# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit webapp

DESCRIPTION="A customizable PHP script that displays information about your system nicely"
HOMEPAGE="https://rk4an.github.com/phpsysinfo/"
SRC_URI="https://github.com/rk4an/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="apcupsd dmraid freeipmi hddtemp ipmitool ipmiutil iptables lm_sensors mdadm megactl nut quota smart snmp uptime"
RDEPEND="dev-lang/php[simplexml,xml,xsl(+),xslt(+),unicode]
	virtual/httpd-php
	apcupsd? ( sys-power/apcupsd )
	dmraid? ( sys-fs/dmraid )
	freeipmi? ( sys-libs/freeipmi )
	hddtemp? ( app-admin/hddtemp )
	ipmitool? ( sys-apps/ipmitool )
	ipmiutil? ( sys-apps/ipmiutil )
	iptables? ( net-firewall/iptables )
	lm_sensors? ( sys-apps/lm_sensors )
	mdadm? ( sys-fs/mdadm )
	megactl? ( sys-block/megactl )
	nut? ( sys-power/nut )
	quota? ( sys-fs/quota )
	smart? ( sys-apps/smartmontools )
	snmp? ( net-analyzer/net-snmp )
	uptime? ( app-misc/uptimed )"

need_httpd_cgi

src_install() {
	webapp_src_preinst

	dodoc CHANGELOG.md README*
	rm CHANGELOG.md COPYING README* .gitignore .travis.yml || die

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	newins phpsysinfo.ini{.new,}

	webapp_configfile "${MY_HTDOCSDIR}"/phpsysinfo.ini

	webapp_src_install
}
