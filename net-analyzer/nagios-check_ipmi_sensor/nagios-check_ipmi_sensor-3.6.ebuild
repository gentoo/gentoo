# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-check_ipmi_sensor/nagios-check_ipmi_sensor-3.6.ebuild,v 1.1 2015/02/07 12:12:20 idl0r Exp $

EAPI=5

inherit multilib versionator

MY_COMMIT="14e6586"
MY_P="${PN#nagios-}_v$(get_major_version $PV)-${MY_COMMIT}"

DESCRIPTION="IPMI Sensor Monitoring Plugin for Nagios/Icinga"
HOMEPAGE="http://www.thomas-krenn.com/en/oss/ipmi-plugin/"
SRC_URI="http://git.thomas-krenn.com/?p=check_ipmi_sensor_v3.git;a=snapshot;h=${MY_COMMIT};sf=tgz -> ${MY_P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl
	dev-perl/IPC-Run
	sys-libs/freeipmi"

S="${WORKDIR}/${MY_P}"

src_install() {
	exeinto /usr/$(get_libdir)/nagios/plugins
	doexe check_ipmi_sensor

	dodoc changelog.txt
}
