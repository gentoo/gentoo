# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit multilib

MY_PV="${PV/_rc/rc}"
MY_P="${PN#nagios-}_v${MY_PV}"

DESCRIPTION="IPMI Sensor Monitoring Plugin for Nagios/Icinga"
HOMEPAGE="http://www.thomas-krenn.com/en/oss/ipmi-plugin/"
SRC_URI="http://www.thomas-krenn.com/en/oss/ipmi-plugin/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
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
