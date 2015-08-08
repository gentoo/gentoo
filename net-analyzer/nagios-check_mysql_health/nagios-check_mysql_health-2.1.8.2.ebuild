# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib autotools

DESCRIPTION="A nagios plugin for checking MySQL server health"
HOMEPAGE="http://labs.consol.de/lang/de/nagios/check_mysql_health/"
SRC_URI="http://labs.consol.de/download/shinken-nagios-plugins/check_mysql_health-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=net-analyzer/nagios-plugins-1.4.13-r1"
RDEPEND="${DEPEND}
	virtual/mysql"

S="${WORKDIR}"/check_mysql_health-${PV}

src_prepare() {
	eautoreconf
}

src_install() {
	exeinto /usr/$(get_libdir)/nagios/plugins
	doexe plugins-scripts/check_mysql_health
}
