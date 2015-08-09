# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils user

MY_P=${P/_beta/b}

DESCRIPTION="Nagios addon to store Nagios data in a MySQL database"
HOMEPAGE="http://www.nagios.org"
SRC_URI="mirror://sourceforge/nagios/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"

DEPEND="
	dev-perl/DBD-mysql
	dev-perl/DBI
	virtual/mysql
"
RDEPEND="
	${DEPEND}
	>=net-analyzer/nagios-core-3.0
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-asprintf.patch \
		"${FILESDIR}"/${P}-sleep.patch
}

src_configure() {
	econf \
		--sysconfdir=/etc/nagios \
		--enable-mysql
}

DOCS=(
	'docs/NDOUTILS DB Model.pdf'
	'docs/NDOUtils Documentation.pdf'
	Changelog
	README
	REQUIREMENTS
	TODO
	UPGRADING
)

src_install() {
	default
	emake DESTDIR="${D}" install-config

	newinitd "${FILESDIR}"/ndo2db.init-nagios3 ndo2db
}

pkg_postinst() {
	elog "To include NDO in your Nagios setup you'll need to activate the NDO broker module"
	elog "in /etc/nagios/nagios.cfg:"
	elog "\tbroker_module=/usr/bin/ndomod-3x.o config_file=/etc/nagios/ndomod.cfg"
}
