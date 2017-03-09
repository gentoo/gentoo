# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='sqlite?'

inherit distutils-r1

DESCRIPTION="Flexible print quota and accounting package for use with CUPS and lpd"
HOMEPAGE="http://www.pykota.com"
SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap mysql postgres snmp sqlite xml"

RDEPEND="
	dev-python/egenix-mx-base[${PYTHON_USEDEP}]
	net-print/pkpgcounter[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pkipplib[${PYTHON_USEDEP}]
	ldap?     ( dev-python/python-ldap[${PYTHON_USEDEP}] )
	mysql?    ( dev-python/mysql-python[${PYTHON_USEDEP}] )
	postgres? ( dev-db/postgresql[server] dev-python/pygresql[${PYTHON_USEDEP}] )
	snmp?     ( net-analyzer/net-snmp dev-python/pysnmp[${PYTHON_USEDEP}] )
	xml?      ( dev-python/jaxml[${PYTHON_USEDEP}] )"
# CUPS required because of cups-config call, #563402
DEPEND="${RDEPEND}
	net-print/cups"

python_prepare_all() {
	sed -i -e 's:from pysqlite2 import dbapi2:import sqlite3:' \
		pykota/storages/sqlitestorage.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	local DOCS=()

	distutils-r1_python_install_all

	dodir /etc/${PN}
	# cups backend ----------------------------------------------

	dodir "$(cups-config --serverbin)/backend"
	dosym "${EPREFIX}"/usr/share/pykota/cupspykota \
		"$(cups-config --serverbin)/backend/cupspykota"

	# extra docs: inits -----------------------------------------

	init_dir="/usr/share/doc/${PF}/initscripts"
	insinto "${init_dir}"
	doins -r initscripts/*

	# Fixes permissions for bug 155865
	fperms 0700 /usr/share/pykota/cupspykota || die

	rm "${ED%/}"/usr/share/doc/${PN}/{LICENSE,COPYING} || die
	mv "${ED%/}"/usr/share/doc/{${PN},${PF}} || die
}
