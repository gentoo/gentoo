# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/kaa-base/kaa-base-0.6.0-r1.ebuild,v 1.7 2015/01/28 10:31:35 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite?,threads(+)"

inherit distutils-r1

DESCRIPTION="Basic Framework for all Kaa Python Modules"
HOMEPAGE="http://freevo.sourceforge.net/kaa/"
SRC_URI="mirror://sourceforge/freevo/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="avahi sqlite tls lirc"

DEPEND=">=dev-libs/glib-2.4.0
	avahi? ( net-dns/avahi[python] )
	sqlite? ( dev-python/dbus-python[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}
	dev-python/pynotifier[${PYTHON_USEDEP}]
	lirc? ( dev-python/pylirc[${PYTHON_USEDEP}] )
	tls? ( dev-python/tlslite[${PYTHON_USEDEP}] )"

DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	sed -i -e 's:from pysqlite2 import dbapi2:import sqlite3:' \
		src/db.py || die

	rm -fr src/pynotifier
	distutils-r1_python_prepare_all
}

python_compile() {
	local CFLAGS="${CFLAGS} -fno-strict-aliasing"
	export CFLAGS
	distutils-r1_python_compile
}
