# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/pykota/pykota-1.26.ebuild,v 1.7 2015/06/09 18:45:08 floppym Exp $

EAPI=3
PYTHON_DEPEND="2"
PYTHON_USE_WITH='sqlite?'

inherit distutils

DESCRIPTION="Flexible print quota and accounting package for use with CUPS and lpd"
HOMEPAGE="http://www.pykota.com"
SRC_URI="http://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap mysql postgres snmp sqlite xml"

DEPEND="dev-lang/python
	dev-python/egenix-mx-base
	net-print/pkpgcounter
	dev-python/chardet
	dev-python/pkipplib
	ldap?     ( dev-python/python-ldap )
	mysql?    ( dev-python/mysql-python )
	postgres? ( dev-db/postgresql[server] dev-python/pygresql )
	snmp?     ( net-analyzer/net-snmp =dev-python/pysnmp-3.4* )
	xml?      ( dev-python/jaxml )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"

DOCS="README TODO SECURITY CREDITS FAQ"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	distutils_src_prepare

	sed -i -e 's:from pysqlite2 import dbapi2:import sqlite3:' \
		pykota/storages/sqlitestorage.py || die
}

src_install() {
	dodir /etc/${PN} || die
	distutils_src_install

	# cups backend ----------------------------------------------

	dodir $(cups-config --serverbin)/backend || die
	dosym /usr/share/pykota/cupspykota $(cups-config --serverbin)/backend/cupspykota || die

	# extra docs: inits -----------------------------------------

	init_dir="/usr/share/doc/${PF}/initscripts"
	insinto "${init_dir}"
	doins -r initscripts/* || die

	# Fixes permissions for bug 155865
	chmod 700 "${D}"/usr/share/pykota/cupspykota

	for doc in ${DOCS}; do
		rm "${D}"/usr/share/doc/${PN}/${doc} || die
	done
	rm "${D}"/usr/share/doc/${PN}/{LICENSE,COPYING} || die
	mv "${D}"/usr/share/doc/${PN}/* "${D}"/usr/share/doc/${PF}/ || die
	rmdir "${D}"/usr/share/doc/${PN} || die
}
